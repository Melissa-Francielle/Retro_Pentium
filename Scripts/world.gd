extends Node2D

@onready var monitor = $Monitor  # Certifique-se de que o nome do nó está correto!
@onready var machine = $Machine  # Referência à máquina na cena

const MAX_DURACAO = 10
const MAX_PRIORIDADE = 10
const MAX_TEMPO_CHEGADA = 10
const NUM_TAREFAS = 4
const QUANTUM = 2 
const MAX_RODADAS = 6

var processos = []  # Lista dos processos gerados
var turnaround_time = 0
var waiting_time = 0
var escalonamento_escolhido = false  # Nenhum escalonamento foi escolhido ainda
var blocos = []  # Lista de blocos de escalonamento
var rodadas = 0 
var rodadas_ruins = 0  # Contabiliza quantos escalonamentos foram ruins


# Chamando no _ready para testar
func _ready():
	AudioController.play_cutscene()
	print("Entrou no _ready do World") # DEBUG
	gerar_processos()
	#exemplo()
	print("Processos gerados:", processos) # DEBUG
	print("Machine existe?", machine != null) # Deve ser true
	print("Monitor existe?", monitor != null) # Deve ser true
	blocos = get_tree().get_nodes_in_group("escalonamento_blocos")  # Pega todos os blocos na cena



# Função para gerar processos aleatórios
func gerar_tarefa(id: int) -> Dictionary:
	return {
		"id": "T" + str(id),
		"tempo_chegada": randi() % MAX_TEMPO_CHEGADA + 1,
		"duracao": randi() % MAX_DURACAO + 1,
		"prioridade": randi() % MAX_PRIORIDADE + 1,
		"tempo_espera": 0,
		"tempo_execucao": 0,
		"quantum": 0
	}

func exemplo():
	processos = [  
		{ "id": "T1", "tempo_chegada": 0, "duracao": 5, "prioridade": 2, "tempo_espera": 0, "tempo_execucao": 0, "quantum": 0 },  
		{ "id": "T2", "tempo_chegada": 0, "duracao": 2, "prioridade": 3, "tempo_espera": 0, "tempo_execucao": 0, "quantum": 0 },  
		{ "id": "T3", "tempo_chegada": 1, "duracao": 4, "prioridade": 1, "tempo_espera": 0, "tempo_execucao": 0, "quantum": 0 },  
		{ "id": "T4", "tempo_chegada": 3, "duracao": 1, "prioridade": 4, "tempo_espera": 0, "tempo_execucao": 0, "quantum": 0 }  
	]  

	monitor.atualizar_monitor(processos)  # Exibe os processos no Monitor

func calcular_tat_wt(processos):
	turnaround_time = 0
	waiting_time = 0
	var soma_tat = 0
	var soma_wt = 0
	
	for i in range(processos.size()):
		var tempo_final = processos[i]["tempo_execucao"]
		var tempo_chegada = processos[i]["tempo_chegada"]
		
		# Turnaround Time
		soma_tat += (tempo_final - tempo_chegada)
		
		# Waiting Time
		if i == 0:
			soma_wt += 0  # Primeiro processo não tem um processo anterior
		else:
			soma_wt += (processos[i-1]["tempo_execucao"] - tempo_chegada)
	
	# Cálculo final
	turnaround_time = float(soma_tat) / processos.size()
	waiting_time = float(soma_wt) / processos.size()
	
	return { "turnaround_time": turnaround_time, "waiting_time": waiting_time }

# Função para gerar e exibir os processos no monitor
func gerar_processos():
	randomize()
	processos.clear()
	
	for i in range(NUM_TAREFAS):
		processos.append(gerar_tarefa(i + 1))  # Gera os 4 processos

	monitor.atualizar_monitor(processos)  # Exibe os processos no Monitor

func aplicar_escalonamento(tipo: String):
	if escalonamento_escolhido:
		print("Já foi escolhido um escalonamento, não pode mudar!")
		return  # Impede que o jogador mude de escalonamento
	escalonamento_escolhido = true  # Agora foi escolhido um escalonamento
	print("Escalonamento escolhido:", tipo)
	# Desabilita os blocos para impedir novas escolhas
	for bloco in blocos:
		bloco.desativar_bloco()
	print("--------------------------------------")
	print("Iniciando escalonamento:", tipo)
	print("Processos antes:")
	for p in processos:
		print(p)
	var processos_ordenados = processos.duplicate(true)
	var tempo_atual = 0
	
	match tipo:
		"FCFS":
			processos_ordenados.sort_custom(func(a, b): return a["tempo_chegada"] < b["tempo_chegada"])
			for p in processos_ordenados:
				if tempo_atual < p["tempo_chegada"]:
					tempo_atual = p["tempo_chegada"]
				p["tempo_espera"] = max(0, tempo_atual - p["tempo_chegada"])
				tempo_atual += p["duracao"]
				p["tempo_execucao"] =  tempo_atual
			for p in processos_ordenados:
				p["turnaround_time"] = p["tempo_execucao"] - p["tempo_chegada"]
				p["waiting_time"] = p["turnaround_time"]-p["duracao"]
				
				print("Processo:", p["id"], "| Espera:", p["tempo_espera"], "| Execução:", p["tempo_execucao"]) 
			
		"SJF":
			var fila = []  # Processos prontos para execução
			var restantes = processos.duplicate(true)  # Processos que ainda não entraram na fila
			tempo_atual = 0
			processos_ordenados.clear()

			# Ordena os processos por tempo de chegada antes de iniciar
			restantes.sort_custom(func(a, b): return a["tempo_chegada"] < b["tempo_chegada"])

			while !fila.is_empty() or !restantes.is_empty():
				# Adiciona processos ao tempo atual na fila de execução
				while !restantes.is_empty() and restantes[0]["tempo_chegada"] <= tempo_atual:
					fila.append(restantes.pop_front())

				# Se a fila está vazia, avança o tempo para o próximo processo disponível
				if fila.is_empty():
					tempo_atual = restantes[0]["tempo_chegada"]
					continue  # Volta ao início do loop para adicionar novos processos

				# Ordena a fila pelo tempo de duração (menor primeiro), mantendo a ordem de chegada em caso de empate
				fila.sort_custom(func(a, b): 
					if a["duracao"] == b["duracao"]:
						return a["tempo_chegada"] < b["tempo_chegada"]
					return a["duracao"] < b["duracao"]
				)

				# Executa o primeiro processo da fila (menor duração)
				var processo_exec = fila.pop_front()

				# Se o tempo atual for menor que o tempo de chegada do processo, ajusta
				if tempo_atual < processo_exec["tempo_chegada"]:
					tempo_atual = processo_exec["tempo_chegada"]

				# Cálculo correto dos tempos
				processo_exec["tempo_espera"] = max(0, tempo_atual - processo_exec["tempo_chegada"])
				tempo_atual += processo_exec["duracao"]
				processo_exec["tempo_execucao"] = tempo_atual
				processo_exec["tempo_total"] = processo_exec["tempo_execucao"] - processo_exec["tempo_chegada"]

				# Adiciona o processo finalizado à lista ordenada
				processos_ordenados.append(processo_exec)

		"SRTF":
			var processos_copia = processos_ordenados.duplicate(true).map(func(p): return p.duplicate())
			var fila = []
			processos_ordenados.clear()
			tempo_atual = 0
			var ultimo_tempo = {}
			var tempo_espera = {}

			# Inicializa controle de tempo para cada processo
			for p in processos_copia:
				ultimo_tempo[p["id"]] = p["tempo_chegada"]
				tempo_espera[p["id"]] = 0

			while processos_copia.size() > 0 or fila.size() > 0:
				# Adiciona novos processos que chegaram à fila
				for i in range(processos_copia.size() - 1, -1, -1):
					var p = processos_copia[i]
					if p["tempo_chegada"] <= tempo_atual:
						fila.append(p)
						processos_copia.remove_at(i)

				# Se a fila está vazia, avança para o próximo processo disponível
				if fila.is_empty():
					tempo_atual = processos_copia[0]["tempo_chegada"] if processos_copia.size() > 0 else tempo_atual
					continue

				# Ordena a fila pelo tempo restante de execução (SRTF)
				fila.sort_custom(func(a, b):
					if a["duracao"] == b["duracao"]:
						return a["tempo_chegada"] < b["tempo_chegada"]
					return a["duracao"] < b["duracao"]
				)

				# Seleciona o primeiro processo da fila (menor tempo restante)
				var processo = fila.pop_front()

				# Calcula o tempo de espera corretamente
				tempo_espera[processo["id"]] += tempo_atual - ultimo_tempo[processo["id"]]

				# Executa por 1 unidade de tempo (preempção possível)
				processo["duracao"] -= 1
				tempo_atual += 1
				ultimo_tempo[processo["id"]] = tempo_atual

				# Se o processo terminou, registra os tempos e remove da fila
				if processo["duracao"] <= 0:
					processo["tempo_execucao"] = tempo_atual
					processo["tempo_total"] = tempo_atual - processo["tempo_chegada"]
					processo["tempo_espera"] = tempo_espera[processo["id"]]
					processos_ordenados.append(processo)
				else:
					# Se não terminou, volta para a fila
					fila.append(processo)

				
		"RR":
			var fila_rr = [] 
			# Inicializando fila de processos para RR
			for p in processos_ordenados:
				fila_rr.append(p)
			
			var quantum = 2  # Definindo o quantum para o Round Robin (ajustar conforme necessário)
			
			while !fila_rr.is_empty():
				var processo = fila_rr.pop_front()
				
				# Se o processo ainda não foi completamente executado
				if processo["duracao"] > 0:
					# Define o tempo de execução do processo baseado no quantum
					var tempo_execucao = min(processo["duracao"], quantum)
					processo["tempo_execucao"] = tempo_atual + tempo_execucao
					
					# Atualizando o tempo de espera
					processo["tempo_espera"] = max(0, tempo_atual - processo["tempo_chegada"])
					
					# Subtrai o tempo de execução do processo
					processo["duracao"] -= tempo_execucao
					
					# Se o processo ainda não terminou, adiciona de volta na fila
					if processo["duracao"] > 0:
						fila_rr.append(processo)
					
					# Atualiza o tempo atual
					tempo_atual += tempo_execucao
					
					# Atualiza o quantum para cada processo
					processo["quantum"] = quantum
					
					print("Processo:", processo["id"], "| Espera:", processo["tempo_espera"], "| Execução:", processo["tempo_execucao"], "| Quantum:", processo["quantum"])


	print("Processos DEPOIS do escalonamento: ", processos_ordenados)
	var resultados = calcular_tat_wt(processos_ordenados)
	machine.mostrar_calculos(resultados["turnaround_time"], resultados["waiting_time"])
	machine.mostrar_resultados(processos_ordenados)
	


func reativar_blocos():
	if rodadas < MAX_RODADAS:
		print("Rodada concluída")
		escalonamento_escolhido = false
		rodadas += 1 
		
		var escalonamento_ruim = machine.atualizar_vida(turnaround_time, waiting_time)
		
		if escalonamento_ruim:
			rodadas_ruins += 1  # Aumenta o contador de rodadas ruins

		
		if rodadas_ruins >= ceil(MAX_RODADAS / 2):
			print("Muitas rodadas ruins! Game Over!")
			get_tree().change_scene_to_file("res://Scenes/tela_game_over.tscn")
			return  # Para a execução aqui, evitando rodadas extras
		
		machine.limpar_tempos() 
		machine.limpar_resultados() 
		
		
		processos.clear()
		for i in range(NUM_TAREFAS):
			processos.append(gerar_tarefa(i+1))
		monitor.atualizar_monitor(processos)
		
		for bloco in blocos:
			bloco.ativar_bloco()
	else:
		print("Máximo de rodadas atingido! Jogo encerrado")
		get_tree().change_scene_to_file("res://Scenes/tela_win.tscn")
