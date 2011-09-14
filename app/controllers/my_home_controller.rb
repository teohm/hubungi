class MyHomeController < ApplicationController
  before_filter :require_auth

  def index
      RestClient.log = 'stdout'
      p account = current_profile.accounts.first

      json = RestClient.get(
          'https://www.google.com/m8/feeds/groups/default/full',
          :params => {
            :v => '3.0',
            :access_token => account.auth_token1,
            :alt => 'json',
            'max-results' => 99999
          }
      )

      hash = JSON.parse(json)

      public_group_id = nil

      groups = hash['feed']['entry']
      groups.each do |entry|
        id = entry['id']['$t']

        

        group = Group.find_or_initialize_by_identifier( id )
        group.name = entry['content']['$t']
        group.account = account
        group.save

        if entry['content']['$t'].downcase == 'public'
          p public_group_id = entry['id']['$t'] #.split('/').pop
          
        end
      end


      json = RestClient.get(
          'https://www.google.com/m8/feeds/contacts/default/full',
          :params => {
            :v => '3.0',
            :access_token => account.auth_token1,
            :alt => 'json',
            'max-results' => 99999,
            :group => public_group_id
          }
      )

      @contacts = []

      hash = JSON.parse(json)

      @foo = JSON.pretty_generate(hash)

      entries = hash['feed']['entry']
      entries.each do |entry|

        @contacts << Hashie::Mash.new(
            :name => name(entry),
            :phone => phone(entry),
            :address => address(entry),
            :tags => tags(entry)
        )
      end
  rescue => ex
    p ex
    p ex.response if ex.respond_to?(:response)
    raise ex
  end

  def tags(entry)
    tags = entry['gContact$groupMembershipInfo'].map do |group|
      g = Group.find_by_identifier group['href']
      g.name if (g and g.is_public?)
    end

    tags.compact.join(', ')
  end

  def name(entry)
    entry['title']['$t']
  end

  def phone(entry)
    phones = entry['gd$phoneNumber']
    phones ? phones.first['$t'] : nil
  end

  def address(entry)
    addresses = entry['gd$structuredPostalAddress']
    addresses ? addresses.first['gd$formattedAddress']['$t'] : nil
  end
end