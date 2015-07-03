import json


class JsonAble():
	def toDict(self):
		outDict = {}
		for property,value in vars(self).iteritems():
			outDict[property] = value
		return outDict

	def fromDict(self, json_dict):
		for property,value in vars(self).iteritems():
			setattr(self, property, json_dict[property])
		return self
