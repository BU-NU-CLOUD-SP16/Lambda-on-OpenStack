require 'json/ext'

class Database
	def getInstance
		return settings.mongo_db
	end

	def findFileFor(username, filename, db)
		if username.length == 0 or filename.length==0
			return -1
		else	
			return _find({"username": username, 
					   "filename": filename}, db)
		end
	end

	def _find(params, db)
		a = :username
		b = :filename

		return fileForUser = db[:mapping].find(a => "#{username}",b =>"#{filename}").count
	end
end