package core

import core.TechSkill.*
import mockSkillsAnswer
import org.junit.jupiter.api.Test
import kotlin.test.assertContentEquals

object SkillsParserTest {
    @Test
    fun `recognizes supported languages`() {
        val skills = SkillsParser.fromAnswer(mockSkillsAnswer).sorted()
        val expected = listOf(JavaScript, TypeScript, Css, Groovy).sorted()
        assertContentEquals(expected, skills)
    }
}
