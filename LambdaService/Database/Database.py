#!/usr/bin/env python

import pymongo as mongo

class Database:
	"database layer for firing queries to mongodb"
	def __init__(self):
		self.dbClient = mongo.MongoClient()
		self.db = self.dbClient.lambdaD

	def insertData(self, params):
		# query = createInsertQuery(params)	
		pass

	def findData(self, user, functionName, eventSource):
		self.__init__()
		data = self.db.mapping.find({"username": user});
		self.dbClient.close()
		return data
	
	def writeFile(self, objId, functionName):
		self.__init__()
		fs =  GridFSBucket(self.db)
		fileName = "/home/ubuntu/"+functionName 
		f = open(fileName,'rwb')
		fs.download_to_stream(objId, f)
		self.dbClient.close()
		# self.db.fs.chunks.find(objId)

	def createFindQuery(self, params):
		if params!=null:
			query = {}
			for key in params:
				query[key] = params[key]
		return query
