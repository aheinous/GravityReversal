extends Node

var deathCount = 0 setget , getDeathCount

func incDeathCount():
	deathCount += 1
	Global.getHUD().setDeathCount(deathCount)

func getDeathCount():
	return deathCount

func onEnterLevel():
	deathCount = 0
