package utils

import core.TeamComposition

fun TeamComposition.format(): String {
    val skills = composition.joinToString("\n\n") { role ->
        val (skill, member) = role

        """
        |Skill:  ${skill.language}
        |Name:   ${member.name.value}
        |Avatar: ${member.avatarUrl.value}
        |GitHub: ${member.profileUrl.value}
        |Skills: ${member.skills.joinToString()}
        """.trimMargin()
    }

    return """
    |Team Composition
    |
    |Skills
    |
    |$skills
    """.trimMargin()
}
