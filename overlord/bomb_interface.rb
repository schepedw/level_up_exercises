require 'rubygems'
require 'sinatra'
require './bomb.rb'
require 'pry'

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql'
)
set :database, :development

def parse_activation_codes(args)
  args.inject({}) do |code_hash, code|
    code_value_pair = code.downcase.split('=').map(&:strip)
    code_hash.merge(Hash[*code_value_pair])
  end
end

def create_bomb
  ARGV.delete('bomb_interface.rb')#hacky way to use shotgun
  codes = parse_activation_codes(ARGV)
  Bomb.create(:activation_code => codes["a"], :deactivation_code => codes["d"])
end

get '/' do
  @bomb = create_bomb
  check_bomb_status(params[:code]) unless params[:code].nil?
  render_html
end

post '/' do
  code = params[:code]
  bomb_id = params[:bomb_id]
  @bomb = Bomb.find(bomb_id) 
  check_bomb_status(code)
  @bomb.save
  render_html
end

def render_html
  "
  <!DOCTYPE html>
  <html>" +
  header +
  body_content +
  "</html>"
end


def header
  "
  <head>
    <title> Super Villain's Bomb! </title>
    <link rel = 'stylesheet' href = 'css/bomb.css'/>
    <script type = 'text/javascript' src = '/js/bomb.js'></script>
  </head>
  "
end

def body_content
  "
  <body>
   <div class = 'outer #{state}'>" +
    "Bomb is #{state}"+
    activation_field +
   "</div>
  </body>"
end

def state
  Bomb.ACTIVE_STATES.include?(@bomb.state) ? "active" : @bomb.state
end


def activation_field
  if @bomb.exploded?
    ""
  else
    "<form id = 'code_input' onsubmit = 'say_hi()' action = '/' method = 'post'>
      <input type ='text' name = 'code' placeholder = 'code'>
      <input type = 'hidden' name = 'bomb_id' value = '#{@bomb.id}'
      <input type = 'submit' id = 'activation_button'>
       </form>
    "
  end
end

def check_bomb_status(code)
  puts "bomb = #{@bomb}"
  @bomb.input_code(code)
end

