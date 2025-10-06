/**
 * @name Function Structural Analysis
 * @description Extracts the CFG, loops, and return statements for a given function.
 * @kind table
 * @id cpp/scope-llm/function-structure
 */

import cpp
import semmle.code.cpp.controlflow.ControlFlowGraph

// Helper to classify different types of CFG nodes
string getNodeType(ControlFlowNode n) {
  if n instanceof LoopEntryNode then result = "LoopEntry"
  else if n.getAstNode() instanceof ReturnStmt then result = "Return"
  else if n.getNumberOfSuccessors() > 1 then result = "Branch"
  else if n = n.getControlFlowGraph().getEntry() then result = "FunctionEntry"
  else result = "Block"
}

// --- Query ---
// Modify "strcmp" to the name of the function you want to analyze
from Function f, ControlFlowGraph cfg, ControlFlowNode n
where
  f.hasGlobalName("strcmp") and
  cfg = f.getControlFlowGraph() and
  n = cfg.getANode()
select
  f.getName() as functionName,
  n.getId() as nodeId,
  n.getAstNode().toString() as nodeContent,
  n.getAstNode().getLocation().toString() as nodeLocation,
  getNodeType(n) as nodeType,
  // List all successor nodes' IDs for building the graph
  concat(ControlFlowNode succ | succ = n.getASuccessor() | succ.getId().toString(), ", ") as successors