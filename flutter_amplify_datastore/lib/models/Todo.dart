/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Todo type in your schema. */
@immutable
class Todo extends Model {
  static const classType = const TodoType();
  final String id;
  final String body;
  final bool isComplete;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const Todo._internal(
      {@required this.id, @required this.body, @required this.isComplete});

  factory Todo({String id, @required String body, @required bool isComplete}) {
    return Todo._internal(
        id: id == null ? UUID.getUUID() : id,
        body: body,
        isComplete: isComplete);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Todo &&
        id == other.id &&
        body == other.body &&
        isComplete == other.isComplete;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Todo {");
    buffer.write("id=" + id + ", ");
    buffer.write("body=" + body + ", ");
    buffer.write(
        "isComplete=" + (isComplete != null ? isComplete.toString() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Todo copyWith({String id, String body, bool isComplete}) {
    return Todo(
        id: id ?? this.id,
        body: body ?? this.body,
        isComplete: isComplete ?? this.isComplete);
  }

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        body = json['body'],
        isComplete = json['isComplete'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'body': body, 'isComplete': isComplete};

  static final QueryField ID = QueryField(fieldName: "todo.id");
  static final QueryField BODY = QueryField(fieldName: "body");
  static final QueryField ISCOMPLETE = QueryField(fieldName: "isComplete");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Todo";
    modelSchemaDefinition.pluralName = "Todos";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.BODY,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.ISCOMPLETE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.bool)));
  });
}

class TodoType extends ModelType<Todo> {
  const TodoType();

  @override
  Todo fromJson(Map<String, dynamic> jsonData) {
    return Todo.fromJson(jsonData);
  }
}
