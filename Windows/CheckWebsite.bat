if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
	cd C:\Users\Igor\Documents\Projects\Coding\CheckWebsite\
	@echo off
	python C:\Users\Igor\Documents\Projects\Coding\CheckWebsite\main.py %*
exit
:: https://stackoverflow.com/a/22357573