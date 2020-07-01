
# TODO: this doesn't handle multiline comments. If you have a multiline comment it will only
# count the first line as a comment and the rest as code, I doubt that multiline comments
# occur often enough to cause serious errors but it would be nice to handle them

class CodeType
    def is_whitespace(line)
        return line.strip.empty?
    end

    def classify(line)
        if is_whitespace(line)
            return :whitespace
        elsif is_comment(line)
            return :comment
        else
            return :code
        end
    end
end

class CStyleCommentCodeType < CodeType
    def is_comment(line)
        line.strip!
        return line.start_with?('//') || line.start_with?('/*')
    end
end

class CppCode < CStyleCommentCodeType
    @@cpp_exts = [ '.h', '.hpp', '.hxx', '.cpp', '.cxx', '.cc', '.c' ]

    def name
        return 'C/C++'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return @@cpp_exts.include?(extension)
    end
end

class CSharpCode < CStyleCommentCodeType
    def name
        return 'C#'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.cs'
    end
end

class ShellScript < CodeType
    def name
        return 'Shell'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.sh'
    end

    def is_comment(line)
        return line.strip.start_with?('#')
    end
end

class Python < CodeType
    def name
        return 'Python'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.py'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('#') || line.start_with?('\"\"\"')
    end
end

class BatchFile < CodeType
    def name
        return 'Batch File'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.cmd' || extension == '.bat'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('rem') || line.start_with?('::')
    end
end

class Assembly < CodeType
    def name
        return 'Assembly'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension == '.s' || extension == '.asm'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('#') || line.start_with?(';')
    end
end

class Xml < CodeType
    def name
        return 'XML'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return extension.downcase == '.xml'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('<!')
    end
end

class MSBuild < CodeType
    @@msbuild_exts = [ '.csproj', '.proj', '.ilproj', '.targets', '.props'  ]

    def name
        return 'MSBuild'
    end

    def is_this_code_type(file_name)
        extension = File.extname(file_name).downcase
        return @@msbuild_exts.include?(extension.downcase)
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('<!')
    end
end

class CMake < CodeType
    @@msbuild_exts = [ '.csproj', '.proj', '.ilproj', '.targets', '.props'  ]

    def name
        return 'CMake'
    end

    def is_this_code_type(file_name)
        return file_name.downcase == 'cmakelists.txt'
    end

    def is_comment(line)
        line.strip!
        return line.start_with?('#')
    end
end
