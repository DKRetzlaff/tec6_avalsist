require 'levenshtein'
require 'mongoid'

load 'venue.rb'
Mongoid.load!("mongoid.yml", :development)

class Algoritmos

	def especifico(trabalho_em_evento)

		conferencias_banco = Venue.where({"venue_type" => "conference"})
		
		ids_de_conferencias = []
		iniciais_de_conferencias_banco = []
		titulos_de_conferencias_banco = []
		flag = 0
		
		titulo_conferencia_trabalho = trabalho_em_evento["conferencia"]
		
		# Percorre as conferencias do banco e verifica se os titulos são parecidos
		conferencias_banco.no_timeout.each do | conferencia_banco |
			
			id_conferencia = conferencia_banco.id.to_s
			titulo_conferencia_banco = conferencia_banco.titles[0].downcase
			inicial_conferencia_banco = conferencia_banco.initials[0]

			if(titulo_conferencia_trabalho.downcase.include?(titulo_conferencia_banco))
				
				return id_conferencia
			
			elsif(inicial_conferencia_banco.length > 3)
				
				if(titulo_conferencia_trabalho.include?(inicial_conferencia_banco))
					
					return id_conferencia
				
				end
			
			end

		end

		return nil
	end

	def generico(trabalho_em_evento)
		
		conferencias = Venue.where({"venue_type" => "conference"})
		
		conferencias.each do | conferencia |
		
			titulo_conferencia_banco = conferencia.titles[0]
			titulo_conferencia_trabalho = trabalho_em_evento["conferencia"]

			# Testa se os títulos são 95% semelhantes através do levenshtein
			if Levenshtein.normalized_distance(titulo_conferencia_banco, titulo_conferencia_trabalho, 0.05)
			
				return conferencia.id.to_s
			
			end
		
		end
		
		return nil
	
	end

end

=begin 
Exemplo de uso:

algoritmo = Algoritmos.new
trabalho_em_evento = {
	"conferencia" => "IEEE Conference on Norbert Wiener in the 21st Century"
}
p algoritmo.especifico(trabalho_em_evento) => 5913168406ce5547ec000000   

trabalho_em_evento = {
	"conferencia" => "IEEE"
}   
p algoritmo.generico(trabalho_em_evento) => nil

=end