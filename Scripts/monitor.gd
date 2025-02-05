extends Node2D

@onready var ingresso_labels = [$T1/I1, $T2/I2, $T3/I3, $T4/I4]
@onready var duracao_labels = [$T1/D1, $T2/D2, $T3/D3, $T4/D4]
@onready var prioridade_labels = [$T1/P1, $T2/P2, $T3/P3, $T4/P4]

# Função para atualizar o monitor com os processos recebidos
func atualizar_monitor(processos: Array):
	for i in range(processos.size()):
		ingresso_labels[i].text = str(processos[i]["tempo_chegada"])
		duracao_labels[i].text = str(processos[i]["duracao"])
		prioridade_labels[i].text = str(processos[i]["prioridade"])
