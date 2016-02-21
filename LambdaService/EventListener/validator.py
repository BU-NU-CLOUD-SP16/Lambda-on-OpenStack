#!/usr/bin/env python

class Validator:
	"validator for Events."
	def validatePayload(self, payload):
		if payload is None:
			return False
		else:
			return True

			