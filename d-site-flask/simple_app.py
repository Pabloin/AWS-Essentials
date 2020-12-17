from flask import Flask, request
app = Flask(__name__)

@app.route("/")
def hello_world():
    return "Hello World"

@app.route('/temp', method=['GET', 'POST'])
def temperature():
    temp = request.args.get("temp")
    return "temp " + temp

if __name__ == '__main__':
    app.run()
