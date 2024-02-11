package core

object SkillsParser {
    fun fromAnswer(answer: String): List<TechSkill> {
        return TechSkill.entries.filter { skill ->
            val name = skill.displayName
            val regex = ".*[^a-zA-Z]$name[^a-zA-Z].*".toRegex()
            answer.contains(regex)
        }
    }
}
