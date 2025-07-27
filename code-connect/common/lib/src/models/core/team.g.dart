// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeamComposition _$TeamCompositionFromJson(Map<String, dynamic> json) =>
    TeamComposition(
      projectDescription: json['projectDescription'] as String,
      roles: (json['roles'] as List<dynamic>)
          .map((e) => ProjectRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TeamCompositionToJson(TeamComposition instance) =>
    <String, dynamic>{
      'projectDescription': instance.projectDescription,
      'roles': instance.roles,
    };

ProjectRole _$ProjectRoleFromJson(Map<String, dynamic> json) => ProjectRole(
      skill: $enumDecode(_$TechSkillEnumMap, json['skill']),
      member: TeamMember.fromJson(json['member'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProjectRoleToJson(ProjectRole instance) =>
    <String, dynamic>{
      'skill': _$TechSkillEnumMap[instance.skill]!,
      'member': instance.member,
    };

const _$TechSkillEnumMap = {
  TechSkill.assembly: 'assembly',
  TechSkill.astro: 'astro',
  TechSkill.awk: 'awk',
  TechSkill.batchfile: 'batchfile',
  TechSkill.c: 'c',
  TechSkill.cSharp: 'cSharp',
  TechSkill.cpp: 'cpp',
  TechSkill.cMake: 'cMake',
  TechSkill.css: 'css',
  TechSkill.clojure: 'clojure',
  TechSkill.coffeeScript: 'coffeeScript',
  TechSkill.cuda: 'cuda',
  TechSkill.cython: 'cython',
  TechSkill.dart: 'dart',
  TechSkill.dockerfile: 'dockerfile',
  TechSkill.ejs: 'ejs',
  TechSkill.fSharp: 'fSharp',
  TechSkill.glsl: 'glsl',
  TechSkill.gherkin: 'gherkin',
  TechSkill.go: 'go',
  TechSkill.groovy: 'groovy',
  TechSkill.h: 'h',
  TechSkill.hlsl: 'hlsl',
  TechSkill.html: 'html',
  TechSkill.hack: 'hack',
  TechSkill.handlebars: 'handlebars',
  TechSkill.innoSetup: 'innoSetup',
  TechSkill.java: 'java',
  TechSkill.javaScript: 'javaScript',
  TechSkill.jinja: 'jinja',
  TechSkill.julia: 'julia',
  TechSkill.jupyterNotebook: 'jupyterNotebook',
  TechSkill.kotlin: 'kotlin',
  TechSkill.less: 'less',
  TechSkill.lex: 'lex',
  TechSkill.lua: 'lua',
  TechSkill.m4: 'm4',
  TechSkill.matlab: 'matlab',
  TechSkill.mdx: 'mdx',
  TechSkill.mlir: 'mlir',
  TechSkill.makefile: 'makefile',
  TechSkill.objectiveC: 'objectiveC',
  TechSkill.objectiveCpp: 'objectiveCpp',
  TechSkill.php: 'php',
  TechSkill.pawn: 'pawn',
  TechSkill.perl: 'perl',
  TechSkill.powerShell: 'powerShell',
  TechSkill.pug: 'pug',
  TechSkill.python: 'python',
  TechSkill.r: 'r',
  TechSkill.raku: 'raku',
  TechSkill.roff: 'roff',
  TechSkill.ruby: 'ruby',
  TechSkill.rust: 'rust',
  TechSkill.sCSS: 'sCSS',
  TechSkill.scilab: 'scilab',
  TechSkill.shaderLab: 'shaderLab',
  TechSkill.shell: 'shell',
  TechSkill.smPL: 'smPL',
  TechSkill.smarty: 'smarty',
  TechSkill.starlark: 'starlark',
  TechSkill.swift: 'swift',
  TechSkill.tml: 'tml',
  TechSkill.tex: 'tex',
  TechSkill.typeScript: 'typeScript',
  TechSkill.unrealScript: 'unrealScript',
  TechSkill.vimSnippet: 'vimSnippet',
  TechSkill.visualBasicDotNet: 'visualBasicDotNet',
  TechSkill.xSsed: 'xSsed',
  TechSkill.yacc: 'yacc',
};

TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => TeamMember(
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String,
      avatarUrl: json['avatarUrl'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => $enumDecode(_$TechSkillEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$TeamMemberToJson(TeamMember instance) =>
    <String, dynamic>{
      'name': instance.name,
      'profileUrl': instance.profileUrl,
      'avatarUrl': instance.avatarUrl,
      'skills': instance.skills.map((e) => _$TechSkillEnumMap[e]!).toList(),
    };
