#coding=utf-8
from flask import Flask
app = Flask(__name__)

@app.route('/index')
@app.route('/home')
def helloworld():
    return 'Welcome to My Watchlist!'

