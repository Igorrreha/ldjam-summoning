@tool
class_name ModulesMapNodeTagsStorage
extends Resource


signal tag_removed(tag: ModulesMapNodeTag)

@export var tags: Array[ModulesMapNodeTag]


func append(tag_to_append: ModulesMapNodeTag) -> void:
	if not tags.any(
			func(tag: ModulesMapNodeTag):
				return tag.resource_name == tag_to_append.resource_name):
		tags.append(tag_to_append)


func remove(tag_to_remove: ModulesMapNodeTag) -> void:
	tags.erase(tag_to_remove)
	tag_removed.emit(tag_to_remove)


func has_tag(tag_name: String) -> bool:
	return tags.any(func(x: ModulesMapNodeTag):
		return x.resource_name == tag_name)


func get_tag_or_null(name: String) -> ModulesMapNodeTag:
	for tag in tags:
		if tag.resource_name == name:
			return tag
	
	return null
