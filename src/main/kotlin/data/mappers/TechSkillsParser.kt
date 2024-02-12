package data.mappers

import core.TechSkill

fun TechSkill.Companion.fromOpenAiAnswer(answer: String): List<TechSkill> {
    return TechSkill.entries.filter { skill ->
        val language = skill.language
        val regex = ".*[^a-zA-Z]$language[^a-zA-Z].*".toRegex()
        answer.contains(regex)
    }
}

fun TechSkill.Companion.fromGitHubLanguage(language: String): TechSkill? {
    return TechSkill.entries.firstOrNull { skill -> skill.language == language }
}
