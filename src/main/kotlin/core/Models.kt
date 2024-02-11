package core

import java.util.*

data class TeamProposal(
        val membersByRole: Map<ProjectRole, List<TeamMember>>,
        val composition: Map<ProjectRole, TeamMember>,
)

data class ProjectRole(
        val name: RoleName,
        val member: TeamMember,
)

data class TeamMember(
        val name: MemberName,
        val profileUrl: ProfileUrl,
        val skills: List<TechSkill>,
)

@JvmInline
value class ProjectDescription(val value: String)

@JvmInline
value class RoleName(val value: String)

@JvmInline
value class ProfileUrl(val value: String)

@JvmInline
value class MemberName(val value: String)

enum class TechSkill(val apiName: String) {
    Assembly("Assembly"),
    Astro("Astro"),
    Awk("Awk"),
    Batchfile("Batchfile"),
    C("C"),
    CSharp("C#"),
    Cpp("C++"),
    CMake("CMake"),
    Css("CSS"),
    Clojure("Clojure"),
    CoffeeScript("CoffeeScript"),
    Cuda("Cuda"),
    Cython("Cython"),
    Dart("Dart"),
    Dockerfile("Dockerfile"),
    Ejs("EJS"),
    FSharp("F#"),
    Glsl("GLSL"),
    Gherkin("Gherkin"),
    Go("Go"),
    Groovy("Groovy"),
    H("H"),
    Hlsl("HLSL"),
    Html("HTML"),
    Hack("Hack"),
    Handlebars("Handlebars"),
    InnoSetup("Inno Setup"),
    Java("Java"),
    JavaScript("JavaScript"),
    Jinja("Jinja"),
    Julia("Julia"),
    JupyterNotebook("Jupyter Notebook"),
    Kotlin("Kotlin"),
    Less("Less"),
    Lex("Lex"),
    Lua("Lua"),
    M4("M4"),
    Matlab("MATLAB"),
    Mdx("MDX"),
    Mlir("MLIR"),
    Makefile("Makefile"),
    ObjectiveC("Objective-C"),
    ObjectiveCpp("Objective-C++"),
    PHP("PHP"),
    Pawn("Pawn"),
    Perl("Perl"),
    PowerShell("PowerShell"),
    Pug("Pug"),
    Python("Python"),
    R("R"),
    Raku("Raku"),
    Roff("Roff"),
    Ruby("Ruby"),
    Rust("Rust"),
    SCSS("SCSS"),
    Scilab("Scilab"),
    ShaderLab("ShaderLab"),
    Shell("Shell"),
    SmPL("SmPL"),
    Smarty("Smarty"),
    Starlark("Starlark"),
    Swift("Swift"),
    Tml("TML"),
    Tex("TeX"),
    TypeScript("TypeScript"),
    UnrealScript("UnrealScript"),
    VimSnippet("Vim Snippet"),
    VisualBasicDotNet("Visual Basic .NET"),
    XSsed("XSsed"),
    Yacc("Yacc"),
}
