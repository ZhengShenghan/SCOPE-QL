/**
 * @name Input Taint to Branch Conditions
 * @description Tracks data flow from function parameters to expressions that control branches and loops.
 * @kind path-problem
 * @id cpp/scope-llm/taint-to-conditions
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

// Configuration for the taint tracking
class TaintToConditionConfig extends TaintTracking::Configuration {
  TaintToConditionConfig() { this = "ScopeLLM_TaintToCondition" }

  override predicate isSource(DataFlow::Node source) {
    // A source is any parameter of the target function
    exists(Function f |
      f.hasGlobalName("strcmp") and
      source.asParameter() = f.getAParameter()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    // A sink is an expression that is used as a condition in an if, for, while, or do-while statement
    exists(Expr e |
      e = sink.asExpr() and
      (
        e.getParent() instanceof IfStmt or
        e.getParent() instanceof ForStmt or
        e.getParent() instanceof WhileStmt or
        e.getParent() instanceof DoStmt
      )
    )
  }
}

// --- Query ---
// Modify "strcmp" in the TaintToConditionConfig to the name of the function
from TaintToConditionConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Taint flow from parameter '" + source.getNode().toString() + "' to condition '" + sink.getNode().toString() + "'"