package core

import core.TechSkill.*
import data.mappers.fromOpenAiAnswer
import mockSkillsAnswer
import org.junit.jupiter.api.Test
import kotlin.test.assertContentEquals

object SkillsParserTest {
    @Test
    fun `recognizes supported languages`() {
        val skills = TechSkill.fromOpenAiAnswer(mockSkillsAnswer).sorted()
        val expected = listOf(JavaScript, TypeScript, Css, Groovy).sorted()
        assertContentEquals(expected, skills)
    }
}
