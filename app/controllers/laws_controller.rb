class LawsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	def create
    laws_of_all_cities = Array.new
		(1..6).each do |city|
			laws_of_all_cities << get_laws_of_a_city("http://nyaaya.in/api/e1/traffic-challan/?city=1")
    end

    puts laws_of_all_cities
		return render(result: laws_of_all_cities, status: :ok)
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
