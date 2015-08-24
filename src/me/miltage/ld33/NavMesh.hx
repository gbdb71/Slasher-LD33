package me.miltage.ld33;

import me.miltage.ld33.math.Vec2;

typedef NavPoint = {x:Float, y:Float, neighbours:Array<NavPoint>, parent:NavPoint};

class NavMesh {

	public var nodes:Array<NavPoint>;
	
	public function new(){
		nodes = new Array<NavPoint>();

		addNode(130, 100);
		addNode(152, 90);
		addNode(175, 90);
		addNode(220, 90);
		addNode(175, 178);
		addNode(125, 175);
		addNode(205, 177);
		addNode(289, 200);
		addNode(290, 225);
		addNode(297, 132);
		addNode(278, 89);
		addNode(300, 100);
		addNode(235, 227);
		addNode(290, 264);
		addNode(337, 225);

	}

	private function addNode(x, y){
		var np = {x:x, y:y, neighbours:[], parent:null};
		for(node in nodes){
			if(LOS.canSee(new Vec2(np.x, np.y), new Vec2(node.x, node.y))){
				node.neighbours.push(np);
				np.neighbours.push(node);
			}
		}
		nodes.push(np);
	}

	public function findPath(p0:Vec2, p1:Vec2):Array<Vec2> {
		var result = new Array<Vec2>();

		if(LOS.canSee(p0, p1, 4, true)){
			result.push(p1);
			return result;
		}

		var startNode = getClosestNode(p0);
		if(startNode == null){
			trace("cant find start node");
			return result;
		}
		var endNode = getClosestNode(p1);
		if(endNode == null){
			trace("cant find end node");
			return result;
		}

		var checked = new Array<NavPoint>();
		var unchecked = new Array<NavPoint>();

		var current = startNode;
		while(current.x != endNode.x || current.y != endNode.y){
			checked.push(current);
			var neighbours = getNeighboursByDistance(current, p1);
			for(n in neighbours){
				if(!arrayContainsNode(checked, n) && !arrayContainsNode(unchecked, n)){
					n.parent = current;
					unchecked.push(n);
				}
			}
			if(unchecked.length == 0){
				trace("could not solve");
				return result;
			}
			current = unchecked.shift();
		}

		result.push(p1);
		while(current.x != startNode.x || current.y != startNode.y){
			result.push(new Vec2(current.x, current.y));
			current = current.parent;
		}
		result.push(new Vec2(startNode.x, startNode.y));

		for(node in nodes) node.parent = null;

		return result;
	}

	private function getNodesByDistance(p:Vec2):Array<NavPoint> {
		var result = nodes.copy();

		for(i in 0...result.length-1){
			for(j in i+1...result.length){
				var di = p.dist(new Vec2(result[i].x, result[i].y));
				var dj = p.dist(new Vec2(result[j].x, result[j].y));
				if(dj < di){
					var t = result[i];
					result[i] = result[j];
					result[j] = t;
				}
			}
		}

		return result;
	}

	private function getClosestNode(p:Vec2):NavPoint {
		var result = getNodesByDistance(p);
		for(node in result){
			if(LOS.canSee(p, new Vec2(node.x, node.y), 1))
				return node;
		}
		return null;
	}

	private function arrayContainsNode(a:Array<NavPoint>, n:NavPoint):Bool {
		for(i in a){
			if(i.x == n.x && i.y == n.y)
				return true;
		}
		return false;
	}

	private function getNeighboursByDistance(n:NavPoint, p:Vec2):Array<NavPoint> {
		var result = n.neighbours.copy();

		for(i in 0...result.length-1){
			for(j in i+1...result.length){
				var di = p.dist(new Vec2(result[i].x, result[i].y));
				var dj = p.dist(new Vec2(result[j].x, result[j].y));
				if(dj < di){
					var t = result[i];
					result[i] = result[j];
					result[j] = t;
				}
			}
		}

		return result;
	}
}