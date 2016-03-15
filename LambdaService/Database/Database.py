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
		data = self.db.mapping.find({"username": user});
		return data
	
	def WriteFile(self, objId, functionName):
		fs =  GridFSBucket(self.db)
		fileName = "/home/ubuntu/"+functionName 
		f = open(fileName,'rwb')
		fs.download_to_stream(objId, f)
		# self.db.fs.chunks.find(objId)

	def createFindQuery(self, params):
		if params!=null:
			query = {}
			for key in params:
				query[key] = params[key]
		return query
