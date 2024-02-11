import org.junit.jupiter.api.Test
import kotlin.test.assertEquals


object SkillsParserTest {
    @Test
    fun `parses example answer to skills`() {
        val skills = SkillsParser.fromAnswer(mockSkillsAnswer)
        val expectedSkills = listOf(TechSkill.Batchfile)
        assertEquals(skills, expectedSkills)
    }
}
