require 'pg'


class SuperheroConnection

  def initialize

    @conn = PG.connect(:dbname =>'superhero', :host => 'localhost')
    @conn.prepare("insert_superhero", "INSERT INTO superheroes (name, alter_ego, has_cape, power, arch_nemesis) VALUES ($1, $2, $3, $4, $5)")
  end

  def delete_all
    @conn.exec( "delete from superheroes" )
  end

  def insert_superhero(name, alter_ego, has_cape, power, arch_nemesis)
   
    @conn.exec_prepared("insert_superhero", [name, alter_ego, has_cape, power, arch_nemesis])
  end

  def print_superhero
    @conn.exec( "SELECT * FROM superheroes ORDER by name desc" ) do |result|
      result.each do |row|
        name = row['name'] || 'null'
        puts "#{ row [ 'alter_ego' ] } goes by #{ row [ 'name' ] } and has the following super power: #{ row[ 'power' ] }."
        
      end
    end
  end

  def yes_has_cape
    @conn.exec( "SELECT * FROM superheroes WHERE has_cape = true" ) do |result|
      result.each do |row|
        has_cape = row['has_cape']
        puts "#{ row [ 'name' ] } wears a cape! That's so freakin cool."
      end
    end
  end

    def no_has_cape
    @conn.exec( "SELECT * FROM superheroes WHERE has_cape = false" ) do |result|
      result.each do |row|
        has_cape = row['has_cape']
        puts "#{ row [ 'name' ] } doesn't wear cape. Bummer."
      end
    end
  end


  def close
    @conn.close
  end
end

begin
  connection = SuperheroConnection.new

  connection.delete_all

  connection.insert_superhero('Superman',      'Clark Kent',                  true,      'super-human abilities',   'Lex Luther')
  connection.insert_superhero('Batman',        'Bruce Wayne',                 true,      'none',                    'Joker')
  connection.insert_superhero('Spider Man',    'Peter Parker',                false,     'spider-like abilities',   'Dr. Octopus')
  connection.insert_superhero('Wonder Woman',  'Diana Prince',                false,     'invisibility',            'Ares')
  connection.insert_superhero('Hulk',          'Robert Bruce Banner',         false,     'super-human strength',    'The Leader')
  connection.insert_superhero('Black Widow',   'Natalia Alianovna Romanova',  false,     'difficult to injure',     'Hydra')
  connection.insert_superhero('Thor',          'Thor Odinson',                true,      'skilled warrior',         'Loki')

 
  connection.print_superhero
  connection.yes_has_cape
  connection.no_has_cape

rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
ensure
  connection.close
end
