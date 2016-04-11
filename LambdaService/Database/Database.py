#!/usr/bin/env python

import pymongo
import gridfs
import json
from bson import json_util

class Database:
	"database layer for firing queries to mongodb"
	def __init__(self):
		self.dbClient = pymongo.MongoClient()
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
		fs =  gridfs.GridFS(self.db)
		fileName = "/home/ubuntu/"+functionName 
		f = open(fileName,'w+')
		content= fs.get(objId).read()
		f.write(content)

	def createFindQuery(self, params):
		if params!=null:
			query = {}
			for key in params:
				query[key] = params[key]
		return query
	def __findLatestRecord(self, user, functionName, eventSource):
		return self.db.mapping.find({"username":user,"filename":functionName,"eventsource":eventSource}).sort([('_id', pymongo.DESCENDING)]).limit(1)
	
	def updateSequenceCount(self, user, functionName, eventSource, log_uuid):
		record=self.__findLatestRecord(user, functionName, eventSource)
		print record[0]['sequence_count']
		if record[0]['sequence_count']>0:
			updated_sequence_count=record[0]['sequence_count']+1
		else:
			updated_sequence_count=1
		return self.db.mapping.insert_one({
                                'filename':record[0]['filename'],
                                'username':record[0]['username'],
                                'eventType':record[0]['eventType'],
                                'eventsource':record[0]['eventsource'],
                                'memory':record[0]['memory'],
                                'sequence_count':updated_sequence_count,
                                'log_uuid':str(log_uuid)})


