package utils

import core.ProjectRole
import core.TeamComposition

fun TeamComposition.describe(): String {
    val skills = roles.joinToString("\n\n") { it.describe() }

    return """
    |Team Composition:
    |
    |[Description]
    |$projectDescription
    |
    |[Roles]
    |$skills
    |
    """.trimMargin()
}

fun ProjectRole.describe(): String {
    return """
    |Skill:  ${skill.language}
    |Name:   ${member.name}
    |Avatar: ${member.avatarUrl}
    |GitHub: ${member.profileUrl}
    |Stack:  ${member.skills.joinToString()}
    """.trimMargin()
}
