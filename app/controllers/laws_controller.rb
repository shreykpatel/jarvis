class LawsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def create
    laws = Array.new
		(1..6).each do |city|
      laws_of_a_city = get_laws_of_a_city("http://nyaaya.in/api/e1/traffic-challan/?city=#{city}")
      persist_laws_of_a_city("traffic-challan", city, laws_of_a_city)
			laws << laws_of_a_city
    end

    return render(nothing: true, status: :ok)
	end

  def persist_laws_of_a_city(genre, location, laws)
    laws.each do |law|
      Law.create(genre: "traffic-challan",
                 location: location,
                 offense: law["traffic_offense"],
                 description: law["simplified"],
                 fine_first_offense: law["fine_first_offense"],
                 prison_first_offense: law["jail_first_offense"],
                 fine_second_offense: law["fine_second_offense"],
                 prison_second_offense: law["jail_second_offense"],
                 additional_information: law["hyperlink"],
                 intents: law["category"]["name"])
    end
  end

  private

	def get_laws_of_a_city(request_for_laws)
    final_response = Array.new
		initial_response = HTTParty.get(request_for_laws)
		initial_response["results"].each do |result|
			final_response << result
    end

		while initial_response["next"] != nil do
			initial_response = HTTParty.get(initial_response["next"])
			initial_response["results"].each do |result|
				final_response << result
      end
		end
		return final_response
	end
end
