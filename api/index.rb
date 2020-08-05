require 'net/http'
require 'json'

Handler = Proc.new do |req, res|
	gist_ids = ['32d91c871fc25674f8a80a210bb66885', '9192249', 'ffc7fc711086ba5f6442537d067f1be9', 'de9224424d14a9d6e185']
	BASE_URL = "https://api.github.com/gists/"
	markdown = []
	begin
		gist_ids.each do |gist_id|
			url = URI.parse(URI.escape(("#{BASE_URL}#{gist_id}")))
			result = Net::HTTP.get_response(url)
			if result.is_a?(Net::HTTPSuccess)
				parsed = JSON.parse(result.body)
				markdown.push("[#{parsed["files"].first[0]}](#{parsed["url"]})")
			end
		end
	rescue Exception => e
		puts "#{"something bad happened"} #{e}"
	end
	res.status = 200
	res['Content-Type'] = 'text/text; charset=utf-8'
	res.body = markdown.join("\n")
end