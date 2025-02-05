extends Node2D

@onready var vida_maquina = $Health
@onready var labels = {
	"Tarefa": [$Tarefa_ID/ID1, $Tarefa_ID/ID2, $Tarefa_ID/ID3, $Tarefa_ID/ID4],
	"Tempo chegada": [$Tempo_chegada/ID1, $Tempo_chegada/ID2, $Tempo_chegada/ID3, $Tempo_chegada/ID4],
	"Tempo total": [$Tempo_total/ID1, $Tempo_total/ID2, $Tempo_total/ID3, $Tempo_total/ID4],
	"Tempo final": [$Tempo_final/ID1, $Tempo_final/ID2, $Tempo_final/ID3, $Tempo_final/ID4],
	"Quantum": [$Quantum/ID1, $Quantum/ID2, $Quantum/ID3, $Quantum/ID4]
}

var index = 0

func _ready():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("machine")

func mostrar_resultados(processos):
	print("Atualizando máquina com processos:", processos)  # DEBUG
	limpar_resultados()  # Garante que os dados antigos são apagados
	index = 0  

	for i in range(processos.size()):
		if index >= labels["Tarefa"].size():
			break
		var p = processos[i]
		labels["Tarefa"][index].text = str(p.get("id", "?"))
		labels["Tempo chegada"][index].text = str(p.get("tempo_chegada", "-"))
		labels["Tempo total"][index].text = str(p.get("duracao", "-"))
		labels["Tempo final"][index].text = str(p.get("tempo_execucao", "-"))
		labels["Quantum"][index].text = str(p.get("quantum", "-"))
		index += 1

		
func atualizar_monitor(nome, chegada, total, final, quantum):
	if index < labels["Tarefa"].size():
		labels["Tarefa"][index].text = nome
		labels["Tempo chegada"][index].text = chegada
		labels["Tempo total"][index].text = total
		labels["Tempo final"][index].text = final
		labels["Quantum"][index].text = quantum
		index += 1

func mostrar_calculos(turnaround_time, waiting_time):
	$Tw.text = "T_espera: %.2f s" % waiting_time
	$Tt.text = "T_execucao: %.2f s" % turnaround_time
	
func limpar_resultados():
	print("Limpando resultados da máquina...")  # DEBUG
	for categoria in labels:
		for label in labels[categoria]:
			label.text = "0"  # Reseta todos os campos de texto

func limpar_tempos():
	print("Limpando tempos Tt e Tw...")  # DEBUG
	$Tw.text = "T_espera: 0.0"
	$Tt.text = "T_execucao: 0.0"
	
func atualizar_vida(turnaround_time, waiting_time) -> bool:
	var perda = 0  
	var escalonamento_ruim = false  # Indica se o escalonamento foi ruim

	# 🔥 Avaliação do escalonamento
	if waiting_time >= 8 or turnaround_time >= 18:
		perda = 20  
		escalonamento_ruim = true  # Foi um escalonamento ruim
	elif waiting_time >= 4 or turnaround_time >= 12:
		perda = 10  
		escalonamento_ruim = true  # Foi um escalonamento médio (ainda conta como ruim)
	else:
		perda = 0  

	
	if perda > 0:
		print("Escalonamento ruim! Perdendo", perda, "de vida.")
		vida_maquina.reduzir_vida(perda)
	else:
		print("Escalonamento foi bom! Nenhuma vida perdida.")

	# Verifica se a vida chegou a zero
	if vida_maquina.health <= 0:
		get_tree().change_scene_to_file("res://Scenes/tela_game_over.tscn")

	return escalonamento_ruim  # Retorna se a rodada foi ruim
