String.prototype.regexIndexOf = function(pattern, startIndex) {
    startIndex = startIndex || 0;
    var searchResult = this.substr(startIndex).search(pattern);
    return (-1 === searchResult) ? -1 : searchResult + startIndex;
}
String.prototype.regexLastIndexOf = function(pattern, startIndex) {
    startIndex = startIndex === undefined ? this.length : startIndex;
    var searchResult = this.substr(0, startIndex).reverse().regexIndexOf(pattern, 0);
    return (-1 === searchResult) ? -1 : this.length - ++searchResult;
}
String.prototype.reverse = function() {
    return this.split('').reverse().join('');
}

function formatter(input) {
    var remove_comments = false;
    var remove_lines = false; // remove blank lines
    var remove_report = false;
    var check_alias = false; // Check ALIAS (every long name is replaced with ALIAS)
    var sign_align = true; // Align signs in PORT()
    var new_line = true; // New line after THEN, semicolon ";"
    var use_space = true;
    var indentation = "    "; // Customized indentation
    var keywordcase = "UpperCase"; // 3 choices: LowerCase, UpperCase, DefaultCase
    var compress = false; // ! EVIL - unreadable (mix upper/lower-case letters)
    var mix_letter = false; // ! EVIL - compress VHDL (\r\n, comments will be removed)

    if (compress) {
        remove_comments = true;
    }

    keyword = ["ABS", "ACCESS", "AFTER", "ALIAS", "ALL", "AND", "ARCHITECTURE", "ARRAY", "ASSERT", "ATTRIBUTE", "BEGIN", "BLOCK", "BODY", "BUFFER", "BUS", "CASE", "COMPONENT", "CONFIGURATION", "CONSTANT", "CONTEXT", "COVER", "DISCONNECT", "DOWNTO", "DEFAULT", "ELSE", "ELSIF", "END", "ENTITY", "EXIT", "FAIRNESS", "FILE", "FOR", "FORCE", "FUNCTION", "GENERATE", "GENERIC", "GROUP", "GUARDED", "IF", "IMPURE", "IN", "INERTIAL", "INOUT", "IS", "LABEL", "LIBRARY", "LINKAGE", "LITERAL", "LOOP", "MAP", "MOD", "NAND", "NEW", "NEXT", "NOR", "NOT", "NULL", "OF", "ON", "OPEN", "OR", "OTHERS", "OUT", "PACKAGE", "PORT", "POSTPONED", "PROCEDURE", "PROCESS", "PROPERTY", "PROTECTED", "PURE", "RANGE", "RECORD", "REGISTER", "REJECT", "RELEASE", "REM", "REPORT", "RESTRICT", "RESTRICT_GUARANTEE", "RETURN", "ROL", "ROR", "SELECT", "SEQUENCE", "SEVERITY", "SHARED", "SIGNAL", "SLA", "SLL", "SRA", "SRL", "STRONG", "SUBTYPE", "THEN", "TO", "TRANSPORT", "TYPE", "UNAFFECTED", "UNITS", "UNTIL", "USE", "VARIABLE", "VMODE", "VPROP", "VUNIT", "WAIT", "WHEN", "WHILE", "WITH", "XNOR", "XOR"];
    var typename = ["BOOLEAN", "BIT", "CHARACTER", "INTEGER", "TIME", "NATURAL", "POSITIVE", "STRING"];
    input = input.replace(/(?:\r\n|\r|\n)/g, '\r\n');
    input = input.replace(/ \r\n/g, '\r\n');
    input = input.replace(/\r\n\r\n\r\n/g, '\r\n');
    input = input.replace(/[\t ]+/g, ' ');
    input = input.replace(/\([\t ]+/g, '\(');
    input = input.replace(/[ ]+;/g, ';');
    input = input.replace(/:[ ]*(PROCESS|ENTITY)/gi, ':$1');
    if (remove_lines) {
        input = input.replace(/(\r\n)*[ \t]*\r\n/g, '\r\n');
    }
    var arr = input.split("\r\n");
    var comments = [],
        comments_i = 0;
    var quotes = [],
        quotes_i = 0;
    var singleline = [],
        singleline_i = 0;
    var align = [],
        align_max = [],
        align_i1 = 0,
        align_i = 0;
    var l = arr.length;
    var str = "",
        str1 = "";
    var k = [],
        n = 0,
        p = 0;
    var n = 0,
        j = 0;
    var tab_n = 1,
        str_len = 0,
        port_s = "";
    var back_tab = false,
        forward_tab = false,
        need_semi = false,
        semi_pos = 0,
        begin_b = false,
        port_b = false;
    for (i = 0; i < l; i++) {
        n = arr[i].regexIndexOf(/[a-zA-Z0-9\(\&\)%_\+'"|]/);
        p = arr[i].indexOf("--");
        if (n < p && n >= 0) {
            var s = arr[i].substr(p);
            comments.push(s);
            arr[i] = arr[i].substr(n, p - n) + "@@comments" + (comments_i++);
        } else if ((n > p && p >= 0) || (n < 0 && p >= 0)) {
            comments.push(arr[i].substr(p));
            arr[i] = "@@comments" + (comments_i++);
        } else {
            n = n < 0 ? 0 : n;
            arr[i] = arr[i].substr(n);
        }
    }
    input = arr.join("\r\n");

    for (var k = 0; k < keyword.length; k++) {
        input = input.replace(new RegExp("([^a-zA-Z0-9_]|^)" + keyword[k] + "([^a-zA-Z0-9_]|$)", 'gi'), "$1" + keyword[k] + "$2");
    }
    for (var k = 0; k < typename.length; k++) {
        input = input.replace(new RegExp("([^a-zA-Z0-9_]|^)" + typename[k] + "([^a-zA-Z0-9_]|$)", 'gi'), "$1" + typename[k] + "$2");
    }
    if (remove_comments) {
        input = input.replace(/@@comments[0-9]+/g, '');
    }
    arr = input.split("\r\n");
    for (i = 0; i < l; i++) {
        k = arr[i].match(/"([^"]+)"/g);
        if (k != null) {
            var u = k.length;
            for (var j = 0; j < u; j++) {
                arr[i] = arr[i].replace(k[j], "@@quotes" + quotes_i);
                quotes[quotes_i++] = k[j];
            }
        }
        if (remove_report) {
            n = arr[i].indexOf("REPORT ");
            p = arr[i].indexOf(";");
            if (need_semi) {
                arr[i] = '';
                if (p >= 0) {
                    need_semi = false;
                }
            }
            if (n >= 0) {
                arr[i] = '';
                if (p < 0) {
                    need_semi = true;
                }
            } else if (n < 0) {
                n = arr[i].indexOf("ASSERT ");
                if (n >= 0) {
                    arr[i] = '';
                    if (p < 0) {
                        need_semi = true;
                    }
                }
            }
        }

        if (arr[i].match(/FUNCTION|PROCEDURE/) != null) {
            arr[i] = arr[i].replace(/;/g, '@@semicolon');
        }
        if (port_s) {
            port_s += arr[i];
            var k_port = port_s.split("(").length;
            if (k_port == port_s.split(")").length) {
                arr[i] = arr[i] + "@@end";
                port_s = "";
                port_b = false;
            }
        }
        if ((!port_b && arr[i].regexIndexOf(/(\s|\(|^)(PORT|GENERIC|PROCESS|PROCEDURE)(\s|\(|$)/) >= 0) || arr[i].regexIndexOf(/:[ ]?=[ ]?\(/) >= 0) {
            arr[i] = arr[i].replace(/(PORT|PROCESS|GENERIC)(\s|\()?\(/, '$1 (');
            port_b = true;
            port_s = arr[i];
            var k_port = port_s.split("(").length;
            if (k_port == 1) {
                port_b = false;
                port_s = "";
            } else if (k_port == port_s.split(")").length) {
                port_s = "";
                port_b = false;
                arr[i] = arr[i] + "@@singleend";
            } else {
                arr[i] = arr[i].replace(/(PORT|PROCESS|GENERIC|PROCEDURE)([a-z0-9A-Z_ ]+)\(([a-zA-Z0-9_\(\) ]+)/, '$1$2(\r\n$3');
            }
        }
        if (!new_line) {
            if (arr[i].regexIndexOf(/(;|THEN)[ a-z0-9]+[a-z0-9]+/) >= 0) {
                singleline[singleline_i] = arr[i];
                arr[i] = "@@singleline" + singleline_i++;
            }
        }
    }
    input = arr.join("\r\n");
    input = input.replace(/([a-zA-Z0-9\); ])\);(@@comments[0-9]+)?@@end/g, '$1\r\n);$2@@end');
    input = input.replace(/[ ]?([&=:\-<>\+|\*])[ ]?/g, ' $1 ');
    input = input.replace(/[ ]?([,])[ ]?/g, '$1 ');
    input = input.replace(/[ ]?(['"])(THEN)/g, '$1 $2');
    input = input.replace(/[ ]?(\?)?[ ]?(<|:|>|\/)?[ ]+(=)?[ ]?/g, ' $1$2$3 ');
    input = input.replace(/(IF)[ ]?([\(\)])/g, '$1 $2');
    input = input.replace(/([\(\)])[ ]?(THEN)/gi, '$1 $2');
    input = input.replace(/(^|[\(\)])[ ]?(AND|OR|XOR|XNOR)[ ]*([\(])/g, '$1 $2 $3');
    input = input.replace(/ ([\-\*\/=+<>])[ ]*([\-\*\/=+<>]) /g, " $1$2 ");
    input = input.replace(/\r\n[ \t]+--\r\n/g, "\r\n");
    input = input.replace(/[ ]+/g, ' ');
    input = input.replace(/\r\n\r\n\r\n/g, '\r\n');
    if (remove_lines) {
        input = input.replace(/(\r\n)*[ \t]*\r\n/g, '\r\n');
    }
    var matches = input.match(/'([a-zA-Z]+)\s/g);
    if (matches != null) {
        for (var k = 0; k < matches.length; k++) {
            input = input.replace(matches[k], matches[k].toUpperCase());
        }
    }
    input = input.replace(/(MAP)[ \r\n]+\(/g, '$1(');
    input = input.replace(/(;|THEN)[ ]?([a-zA-Z])/g, '$1\r\n$2');
    input = input.replace(/(;|THEN)[ ]?(@@comments[0-9]+)([a-zA-Z])/g, '$1 $2\r\n$3');
    input = input.replace(/[\r\n ]+RETURN/g, ' RETURN');
    input = input.replace(/BEGIN[\r\n ]+/g, 'BEGIN\r\n');
    input = input.replace(/ (PORT|GENERIC) /g, '\r\n$1 ');
    if (check_alias) {
        var alias = [],
            subarr = [],
            o = 0,
            p = 0,
            p2 = 0,
            l2 = 0,
            i2 = 0;
        arr = input.split("ARCHITECTURE ");
        l = arr.length;
        for (i = 0; i < l; i++) {
            subarr = arr[i].split("ALIAS ");
            l2 = subarr.length;
            if (l2 > 1) {
                var o;
                for (i2 = 1; i2 < l2; i2++) {
                    o = subarr[i2].indexOf(";", n);
                    str = subarr[i2].substring(0, o);
                    alias[p2++] = str.split(" IS ");
                }
                i2--;
                var str2 = subarr[i2].substr(o);
                for (p = 0; p < p2; p++) {
                    var reg = new RegExp(alias[p][1], 'gi');
                    str2 = str2.replace(reg, alias[p][0]);
                }
                subarr[i2] = subarr[i2].substring(0, o) + str2;
            }
            arr[i] = subarr.join("ALIAS ");
        }
        input = arr.join("ARCHITECTURE ");
    }
    arr = input.split("\r\n");
    l = arr.length;
    var signAlignPos = "";
    var if_b = 0,
        white_space = "",
        case_b = false,
        case_n = 0,
        procfun_b = false,
        semi_b = false,
        set_false = false,
        entity_b = false,
        then_b = false,
        conditional_b = false,
        case_indent = [0, 0, 0, 0, 0, 0, 0];
    for (i = 0; i < l; i++) {
        str = arr[i];
        str_len = str.length;
        if (str.replace(/[ \-\t]*/, "").length > 0) {
            var first_word = str.split(" ")[0];
            if (then_b) {
                arr[i] = " " + arr[i];
                if (str.indexOf(" THEN") >= 0) {
                    then_b = false;
                    back_tab = true;
                }
            }
            arr[i] = white_space + arr[i];
            if (first_word == "ELSIF") {
                tab_n--;
                back_tab = true;
            } else if (str.indexOf("END CASE") == 0) {
                case_n--;
                tab_n--;
                tab_n--;
            } else if (first_word == "END") {
                tab_n--;
                if (str.indexOf("END IF") == 0) {
                    if_b--;
                }
            } else if (first_word == "ELSE" && if_b) {
                tab_n--;
                back_tab = true;
            } else if (case_n) {
                if (first_word == "WHEN") {
                    tab_n = case_indent[case_n - 1];
                    back_tab = true;
                }
            } else if (first_word == "BEGIN") {
                if (begin_b) {
                    tab_n--;
                    back_tab = true;
                    begin_b = false;
                    if (procfun_b) {
                        tab_n++;
                        begin_b = true;
                    }
                } else {
                    back_tab = true;
                }
            } else if (str.indexOf(": PROCESS") >= 0) {
                back_tab = true;
                begin_b = true;
            } else if (str.indexOf(": ENTITY") >= 0) {
                back_tab = true;
                entity_b = true;
            } else if (str.indexOf("PROCEDURE ") >= 0) {
                back_tab = true;
                begin_b = true;
            }

            if (str.indexOf("PORT MAP") >= 0) {
                back_tab = true;
                port_b = true;
                if (str.indexOf(");") < 0) {
                    align_i1 = align_i;
                    var t = str.indexOf("=>");
                    if (t >= 0) {
                        signAlignPos = "=>";
                    } else {
                        t = arr[i + 1].indexOf("=>");
                        if (t >= 0) {
                            signAlignPos = "=>";
                        }
                    }
                } else {
                    signAlignPos = "";
                }
            } else if (str.indexOf("PORT (") >= 0) {
                back_tab = true;
                port_b = true;
                t = str.indexOf(":");
                if (str.indexOf(");") < 0) {
                    align_i1 = align_i;
                    if (t >= 0) {
                        signAlignPos = ":";
                    } else {
                        t = arr[i + 1].indexOf(":");
                        if (t >= 0) {
                            signAlignPos = ":";
                        }
                    }
                } else {
                    signAlignPos = "";
                }
            }
            if (set_false) {
                procfun_b = false;
                set_false = false;
            }
            if (str.indexOf("(") >= 0) {
                if (str.indexOf("PROCEDURE") >= 0 || str.indexOf("FUNCTION") >= 0) {
                    procfun_b = true;
                    back_tab = true;
                }
                if (str.indexOf("GENERIC") >= 0 || str.indexOf(":= (") >= 0 || str.regexIndexOf(/PROCEDURE[a-zA-Z0-9_ ]+\(/) >= 0) {
                    port_b = true;
                    back_tab = true;
                }
            } else if (first_word == "FUNCTION") {
                back_tab = true;
                begin_b = true;
            }
            if (str.indexOf("@@singleend") >= 0) {
                back_tab = false;
                port_b = false;
            } else if (str.indexOf("@@end") >= 0 && port_b) {
                port_b = false;
                tab_n--;
                if (entity_b) {
                    forward_tab = true;
                }
            }
            if (sign_align) {
                if (port_b && signAlignPos != "") {
                    if (str.indexOf(signAlignPos) >= 0) {
                        var a1 = arr[i].split(signAlignPos);
                        var l1 = a1[0].length;
                        if (align_i >= 0 && align_i > align_i1) {
                            align_max[align_i] = align_max[align_i - 1];
                        } else {
                            align_max[align_i] = l1;
                        }
                        if (align_i > align_i1 && align_max[align_i] < l1) {
                            for (var k = align_i1; k <= align_i; k++) {
                                align_max[k] = l1;
                            }
                        }
                        align[align_i] = l1;
                        arr[i] = a1[0] + "@@align" + (align_i++) + signAlignPos + a1[1];
                    }
                }
            }
            tab_n = tab_n < 1 ? 1 : tab_n;
            if (str_len) {
                arr[i] = (Array(tab_n).join(indentation)) + arr[i]; //indent
            }
            if (back_tab) {
                tab_n++;
                back_tab = false;
            }
            if (forward_tab) {
                tab_n--;
                forward_tab = false;
            }

            if (conditional_b && str.indexOf(";") >= 0) {
                //tab_n--;
                conditional_b = false;
                white_space = "";
            } else if (str.indexOf(";") >= 0 && semi_b) {
                semi_b = false;
                tab_n--;
            } else if (!semi_b && str.indexOf(";") < 0 && !port_b) {
                if (!conditional_b) {
                    if (str.indexOf("WHEN") > 3 && str.indexOf("<=") > 1) {
                        conditional_b = true;
                        white_space = (Array(str.indexOf("= ") + 3).join(" "));
                    } else if (str.indexOf("=>") < 0 && ((str.indexOf("@@quotes") >= 0 && str.indexOf("= @@quotes") < 0) || (str.indexOf("<=") > 0 && str.indexOf("IF") < 0 && str.indexOf("THEN") < 0))) {
                        tab_n++;
                        semi_b = true;
                    }
                }
            }

            if (",ENTITY,RECORD,PACKAGE,FOR,COMPONENT,CONFIGURATION,".indexOf("," + first_word + ",") >= 0) {
                tab_n++;
            } else if (str.indexOf(": FOR ") >= 0) {
                tab_n++;
            } else if (first_word == "CASE") {
                tab_n++;
                case_indent[case_n] = tab_n;
                case_n++;
            } else if (first_word == "ARCHITECTURE") {
                tab_n++;
                begin_b = true;
            } else if (first_word == "IF") {
                if_b++;
                tab_n++;
                if (str.indexOf(" THEN") < 0) {
                    then_b = true;
                    tab_n--;
                }
            }
            if (procfun_b) {
                if (str.regexIndexOf(/(\))|(RETURN [A-Za-z0-9 ]+)[\r\n ]+IS/) >= 0) {
                    tab_n--;
                    set_false = true;
                }
            }
        }
    }

    input = arr.join("\r\n");

    if (sign_align) {
        for (var k = 0; k < align_i; k++) {
            input = input.replace("@@align" + k, Array((align_max[k] - align[k] + 2)).join(" "));
        }
    }
    for (var k = 0; k < quotes_i; k++) {
        input = input.replace("@@quotes" + k, quotes[k]);
    }
    for (var k = 0; k < singleline_i; k++) {
        input = input.replace("@@singleline" + k, singleline[k]);
    }
    for (var k = 0; k < comments_i; k++) {
        input = input.replace("@@comments" + k, comments[k]);
    }
    input = input.replace(/@@semicolon/g, ";");
    input = input.replace(/@@[a-z]+/g, "");
    if (keywordcase == "LowerCase") {
        for (var k = 0; k < keyword.length; k++) {
            keyword[k] = keyword[k].toLowerCase();
        }
        for (var k = 0; k < typename.length; k++) {
            typename[k] = typename[k].toLowerCase();
        }
    } else if (keywordcase == "DefaultCase") {
        for (var k = 0; k < keyword.length; k++) {
            keyword[k] = keyword[k].charAt(0) + keyword[k].slice(1).toLowerCase();
        }
        for (var k = 0; k < typename.length; k++) {
            typename[k] = typename[k].charAt(0) + typename[k].slice(1).toLowerCase();
        }
    }
    if (keywordcase != "UpperCase") {
        for (var k = 0; k < keyword.length; k++) {
            input = input.replace(new RegExp("([^a-zA-Z0-9_]|^)" + keyword[k] + "([^a-zA-Z0-9_]|$)", 'gi'), "$1" + keyword[k] + "$2");
        }
        for (var k = 0; k < typename.length; k++) {
            input = input.replace(new RegExp("([^a-zA-Z0-9_]|^)" + typename[k] + "([^a-zA-Z0-9_]|$)", 'gi'), "$1" + typename[k] + "$2");
        }
    }
    if (compress) {
        input = input.replace(/\r\n/g, '');
        input = input.replace(/[\t ]+/g, ' ');
        input = input.replace(/[ ]?([&=:\-<>\+|])[ ]?/g, '$1');
    }
    if (mix_letter) {
        arr = input.split("");
        for (var k = 0; k < arr.length; k++) {
            if (arr[k] === arr[k].toUpperCase() && Math.random() > 0.5) {
                arr[k] = arr[k].toLowerCase();
            } else if (Math.random() > 0.5) {
                arr[k] = arr[k].toUpperCase();
            }
        }
        input = arr.join("");
    }
    return input;
}

if (process.argv.length < 3) {
    console.log("Not enough parameters.");
    process.exit();
};

var fs = require('fs');
var files = process.argv.slice(2);
files.forEach(function(f) {
    if (!fs.existsSync(f)) {
        console.log("Error: No such file: " + f);
        return;
    }
    fs.readFile(f, "utf-8", function(err, data) {
        if (err) throw err;
        var output = formatter(data);
        fs.writeFile(f, output, function(err) {
            if (err) throw err;
            console.log("Successfully processed: " + f);
        })
    })
});