require 'JWT'

class JsonWebToken
	class << self
    def encode(payload, exp = 7.days.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, "$2a$10$zWQKG9p1fi4h2I4vorG6b.")
		end	

	def decode(token) 
		body = JWT.decode(token, "$2a$10$zWQKG9p1fi4h2I4vorG6b.")[0]
		HashWithIndifferentAccess.new(body)
		rescue
			nil 
		end
	end
end
