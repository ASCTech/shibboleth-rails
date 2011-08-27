module Shibboleth::Rails

	module ModelAdditions
		def find_or_create_from_shibboleth(identity)
			user = find_or_create_by_emplid(identity)

			# names change due to marriage, etc.
			# update_attribute is a NOOP if not different
			user.update_attribute(:name_n, identity[:name_n])

			user
		end
	end

end
