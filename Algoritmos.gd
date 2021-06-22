extends Node2D

var mapa: TileMap
var tam_celda: Vector2
var dim: Rect2
const ROCA = 5
const ROCA2 = 4

class nodo:
	var nivel: int
	var pos: Vector2
	var padre: nodo
	var f: float
	func _init(padre_, pos_, destino):
		self.padre = padre_
		if self.padre == null:
			self.nivel = 0
		else:
			self.nivel = self.padre.nivel + 1
		var dx = abs(pos.x - destino.x)
		var dy = abs(pos.y - destino.y)
		self.f = dx + dy + self.nivel
		self.pos = pos_
	
				
func setup(mapa_: TileMap):
	self.mapa = mapa_
	tam_celda = mapa_.cell_size
	dim = mapa.get_used_rect()
	
func buscar_pos(nodos, pos):
	var idx = 0
	for n in nodos:
		if n.pos == pos:
			return idx
		idx += 1
	return -1

func generar_ruta(nodo):
	var ruta = []
	while nodo != null:
		ruta.push_front(nodo.pos)
		nodo = nodo.padre
	return ruta
		
func BPI(actual, destino):
	var p = 0
	while true:
		var visitados = [actual]
		var n = BPP(p, visitados, nodo.new(null, actual, destino), destino)
		if n != null:
			return generar_ruta(n)
		p += 1
		
func BPP(profundidad, visitados, actual, destino):
	if profundidad >= 0:
		if actual.pos == destino:
			return actual
		for v in vecinos(actual.pos):
			if v in visitados:
				continue
			visitados.append(v)
			var n1 = nodo.new(actual, v, destino)
			var n2 = BPP(profundidad - 1, visitados, n1, destino)
			if n2 != null:
				return n2
	return null
	
func AStar(inicio, destino):
	var open_list = [nodo.new(null, inicio, destino)]
	var closed_list = []
	var best: nodo
	while !open_list.empty():
		var minn = 1000000
		var idx = 0
		var i = 0
		for n in open_list:
			if n.f < minn:
				minn = n.f
				i = idx
			idx += 1	
		best = open_list[i]
		if best.pos == destino:
			break
		var hijos = vecinos(best.pos)
		for h in hijos:
			var n = nodo.new(best, h, destino)
			var j = buscar_pos(closed_list, n.pos)
			if j != -1:
				continue
			j = buscar_pos(open_list, n.pos)
			if j != -1 and open_list[j].nivel <= n.nivel:
				continue
			open_list.append(n)
		closed_list.append(best)
		open_list.remove(i)
		#open_list.sort_custom(Sorter, "sort_ascending")
	
	return generar_ruta(best)

	
func BFS(inicio, destino):
	var visitados = []
	var nodos = {inicio: null}
	var cola = [inicio]
	while !cola.empty():
		var nodo = cola[0]
		cola.erase(nodo)
		visitados.append(nodo)
		if nodo == destino:
			break
		var hijos = vecinos(nodo)
		for h in hijos:
			if h in visitados or h in cola:
				continue
			nodos[h] = nodo
			cola.append(h)
	
	var nodo = destino
	var ruta = [nodo]
	while nodo != null:
		var padre = nodos[nodo]
		if padre != null:
			ruta.push_front(padre)
		nodo = padre
	return ruta
		
func vecinos(nodo):		
	var coords = [Vector2(-1,0), Vector2(0,-1), Vector2(1,0), Vector2(0,1)]
	var nodos = []
	for c in coords:
		var v = nodo + c
		var celda = mapa.get_cell(v.x, v.y)
		if celda == -1 or celda == ROCA or celda == ROCA2:
			continue
		nodos.append(v)
	return nodos
	
func _ready():
	pass # Replace with function body.

