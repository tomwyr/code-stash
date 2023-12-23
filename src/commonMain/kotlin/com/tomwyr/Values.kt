import kotlin.jvm.JvmInline

@JvmInline
value class SemanticVersion(val value: String) {
    init {
        val pattern = Regex("^[0-9]+\\.[0-9]+\\.[0-9]+$")
        require(value.matches(pattern)) {
            "Value doesn't follow the semantic versioning pattern."
        }
    }
}
