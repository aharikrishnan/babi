#
# @TODO: Add description of methods
#
TreeHooks = Struct.new(:_before,:_after) do
  def before &blk
    if block_given?
      self._before = blk
    else
      _before
    end
  end

  def after &blk
    if block_given?
      self._after = blk
    else
      _after
    end
  end
end

def trek forest, parent=nil, &blk
  tree_hooks=TreeHooks.new
  if block_given?
    blk.call(tree_hooks)
  end

  walk(forest, nil, tree_hooks)
end

def walk forest, parent, tree_hooks
  return if forest.nil?
  forest.each do |tree|
    result = nil
    if !tree_hooks.before.nil?
      result = tree_hooks.before.call(tree, parent)
    end

    climb(tree, forest, tree_hooks)

    if !tree_hooks.after.nil?
      tree_hooks.after.call(tree, parent, result)
    end
  end
end

def climb tree, parent, tree_hooks
  walk(tree['c'], tree, tree_hooks)
end

