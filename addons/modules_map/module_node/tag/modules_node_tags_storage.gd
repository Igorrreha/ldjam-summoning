@tool
class_name ModulesMapNodeTagsStorage
extends Resource


signal tag_removed(tag: ModulesMapNodeTag)
signal tag_changed(tag: ModulesMapNodeTag)

@export var tags: Array[ModulesMapNodeTag]


func append(tag_to_append: ModulesMapNodeTag) -> void:
	if not tags.any(
			func(tag: ModulesMapNodeTag):
				return tag.resource_name == tag_to_append.resource_name):
		tags.append(tag_to_append)
		
		tag_to_append.changed.connect(_on_tag_changed.bind(tag_to_append))
		_on_tag_changed(tag_to_append)


func remove(tag_to_remove: ModulesMapNodeTag) -> void:
	tags.erase(tag_to_remove)
	tag_removed.emit(tag_to_remove)
	
	_on_tag_changed(tag_to_remove)
	tag_to_remove.about_to_destroy.emit()
	
	if tag_to_remove.changed.is_connected(_on_tag_changed):
		tag_to_remove.changed.disconnect(_on_tag_changed)


func has_tag(tag_name: String) -> bool:
	return tags.any(func(x: ModulesMapNodeTag):
		return x.resource_name == tag_name)


func get_tag_or_null(name: String) -> ModulesMapNodeTag:
	for tag in tags:
		if tag.resource_name == name:
			return tag
	
	return null


func clear() -> void:
	for tag in tags:
		remove(tag)


func _on_tag_changed(tag: ModulesMapNodeTag) -> void:
	tag_changed.emit(tag)
