// Copyright (c) 2019-2022 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.
//
// Utility functions helping integrate with various shell auto-completion systems.
// The install process and communication is inspired from that of [kitty](https://sw.kovidgoyal.net/kitty/#completion-for-kitty)
// This method avoids writing and maintaining external files on the user's file system.
// The user will be responsible for adding a small line to their .*rc - that will ensure *live* (i.e. not-static)
// auto-completion features.
//
// # bash
// To install auto-completion for V in bash, simply add this code to your `~/.bashrc`:
// `source /dev/stdin <<<"$(v complete setup bash)"`
// On more recent versions of bash (>3.2) this should suffice:
// `source <(v complete setup bash)`
//
// # fish
// For versions of fish <3.0.0, add the following to your `~/.config/fish/config.fish`
// `v complete setup fish | source`
// Later versions of fish source completions by default.
//
// # zsh
// To install auto-completion for V in zsh - please add the following to your `~/.zshrc`:
// ```
// autoload -Uz compinit
// compinit
// # Completion for v
// v complete setup zsh | source /dev/stdin
// ```
// Please note that you should let v load the zsh completions after the call to compinit
//
// # powershell
// To install auto-complete for V in PowerShell, simply do this
// `v complete setup powershell >> $PROFILE`
// and reload profile
// `& $PROFILE`
// If `$PROFILE` didn't exist yet, create it before
// `New-Item -Type File -Force $PROFILE`
//
module main

import os

const (
	auto_complete_shells = ['bash', 'fish', 'zsh', 'powershell'] // list of supported shells
	vexe                 = os.getenv('VEXE')
	help_text            = "Usage:
  v complete [options] [SUBCMD] QUERY...

Description:
  Tool for bridging auto completion between various shells and v

Supported shells:
  bash, fish, zsh, powershell

Examples:
  Echo auto-detected shell install script to STDOUT
    v complete
  Echo specific shell install script to STDOUT
    v complete setup bash
  Auto complete input `v tes`*USER PUSHES TAB* (in Bash compatible format).
  This is not meant for manual invocation - it's called by the relevant
  shell via the script installed with `v complete` or `v complete setup SHELL`.
    v complete bash v tes

Options:
  -h, --help                Show this help text.

SUBCMD:
  setup     : setup [SHELL] - returns the code for completion setup for SHELL
  bash      : [QUERY]       - returns Bash compatible completion code with completions computed from QUERY
  fish      : [QUERY]       - returns Fish compatible completion code with completions computed from QUERY
  zsh       : [QUERY]       - returns ZSH  compatible completion code with completions computed from QUERY
  powershell: [QUERY]       - returns PowerShell compatible completion code with completions computed from QUERY"
)

// Snooped from cmd/v/v.v, vlib/v/pref/pref.v
const (
	auto_complete_commands     = [
		// simple_cmd
		'ast',
		'doc',
		'vet',
		// tools in one .v file
		'bin2v',
		'bug',
		'build-examples',
		'build-tools',
		'build-vbinaries',
		'bump',
		'check-md',
		'complete',
		'compress',
		'create',
		'doctor',
		'fmt',
		'gret',
		'repl',
		'self',
		'setup-freetype',
		'shader',
		'symlink',
		'test-all',
		'test-cleancode',
		'test-fmt',
		'test-parser',
		'test-self',
		'test',
		'tracev',
		'up',
		'watch',
		'wipe-cache',
		// commands
		'help',
		'new',
		'init',
		'complete',
		'translate',
		'self',
		'search',
		'install',
		'update',
		'upgrade',
		'outdated',
		'list',
		'remove',
		'vlib-docs',
		'get',
		'version',
		'run',
		'build',
		'build-module',
	]
	auto_complete_flags        = [
		'-apk',
		'-show-timings',
		'-check-syntax',
		'-check',
		'-v',
		'-progress',
		'-silent',
		'-g',
		'-cg',
		'-repl',
		'-live',
		'-sharedlive',
		'-shared',
		'--enable-globals',
		'-enable-globals',
		'-autofree',
		'-compress',
		'-freestanding',
		'-no-preludes',
		'-prof',
		'-profile',
		'-profile-no-inline',
		'-prod',
		'-simulator',
		'-stats',
		'-obfuscate',
		'-translated',
		'-color',
		'-nocolor',
		'-showcc',
		'-show-c-output',
		'-experimental',
		'-usecache',
		'-prealloc',
		'-parallel',
		'-native',
		'-W',
		'-keepc',
		'-w',
		'-print-v-files',
		'-error-limit',
		'-message-limit',
		'-os',
		'-printfn',
		'-cflags',
		'-define',
		'-d',
		'-cc',
		'-o',
		'-b',
		'-path',
		'-custom-prelude',
		'-name',
		'-bundle',
		'-V',
		'-version',
		'--version',
	]
	auto_complete_flags_doc    = [
		'-all',
		'-f',
		'-h',
		'-help',
		'-m',
		'-o',
		'-readme',
		'-v',
		'-filename',
		'-pos',
		'-no-timestamp',
		'-inline-assets',
		'-theme-dir',
		'-open',
		'-p',
		'-s',
		'-l',
	]
	auto_complete_flags_fmt    = [
		'-c',
		'-diff',
		'-l',
		'-w',
		'-debug',
		'-verify',
	]
	auto_complete_flags_bin2v  = [
		'-h',
		'--help',
		'-m',
		'--module',
		'-p',
		'--prefix',
		'-w',
		'--write',
	]
	auto_complete_flags_shader = [
		'help',
		'h',
		'force-update',
		'u',
		'verbose',
		'v',
		'slang',
		'l',
		'output',
		'o',
	]
	auto_complete_flags_self   = [
		'-prod',
	]
	auto_complete_compilers    = [
		'cc',
		'gcc',
		'tcc',
		'tinyc',
		'clang',
		'mingw',
		'msvc',
	]
)

// auto_complete prints auto completion results back to the calling shell's completion system.
// auto_complete acts as communication bridge between the calling shell and V's completions.
fn auto_complete(args []string) {
	if args.len <= 1 || args[0] != 'complete' {
		if args.len == 1 {
			shell_path := os.getenv('SHELL')
			if shell_path.len > 0 {
				shell_name := os.file_name(shell_path).to_lower()
				if shell_name in auto_complete_shells {
					println(setup_for_shell(shell_name))
					exit(0)
				}
				eprintln('Unknown shell ${shell_name}. Supported shells are: $auto_complete_shells')
				exit(1)
			}
			eprintln('auto completion require arguments to work.')
		} else {
			eprintln('auto completion failed for "$args".')
		}
		exit(1)
	}
	sub := args[1]
	sub_args := args[1..]
	match sub {
		'setup' {
			if sub_args.len <= 1 || sub_args[1] !in auto_complete_shells {
				eprintln('please specify a shell to setup auto completion for ($auto_complete_shells).')
				exit(1)
			}
			shell := sub_args[1]
			println(setup_for_shell(shell))
		}
		'bash' {
			if sub_args.len <= 1 {
				exit(0)
			}
			mut lines := []string{}
			list := auto_complete_request(sub_args[1..])
			for entry in list {
				lines << "COMPREPLY+=('$entry')"
			}
			println(lines.join('\n'))
		}
		'fish', 'powershell' {
			if sub_args.len <= 1 {
				exit(0)
			}
			mut lines := []string{}
			list := auto_complete_request(sub_args[1..])
			for entry in list {
				lines << '$entry'
			}
			println(lines.join('\n'))
		}
		'zsh' {
			if sub_args.len <= 1 {
				exit(0)
			}
			mut lines := []string{}
			list := auto_complete_request(sub_args[1..])
			for entry in list {
				lines << 'compadd -U -S' + '""' + ' -- ' + "'$entry';"
			}
			println(lines.join('\n'))
		}
		'-h', '--help' {
			println(help_text)
		}
		else {}
	}
	exit(0)
}

// append_separator_if_dir is a utility function.that returns the input `path` appended an
// OS dependant path separator if the `path` is a directory.
fn append_separator_if_dir(path string) string {
	if os.is_dir(path) && !path.ends_with(os.path_separator) {
		return path + os.path_separator
	}
	return path
}

// nearest_path_or_root returns the nearest valid path searching
// backwards from `path`.
fn nearest_path_or_root(path string) string {
	mut fixed_path := path
	if !os.is_dir(fixed_path) {
		fixed_path = path.all_before_last(os.path_separator)
		if fixed_path == '' {
			fixed_path = '/'
		}
	}
	return fixed_path
}

// auto_complete_request retuns a list of completions resolved from a full argument list.
fn auto_complete_request(args []string) []string {
	// Using space will ensure a uniform input in cases where the shell
	// returns the completion input as a string (['v','run'] vs. ['v run']).
	split_by := ' '
	request := args.join(split_by)
	mut do_home_expand := false
	mut list := []string{}
	// new_part := request.ends_with('\n\n')
	mut parts := request.trim_right(' ').split(split_by)
	if parts.len <= 1 { // 'v <tab>' -> top level commands.
		for command in auto_complete_commands {
			list << command
		}
	} else {
		mut part := parts.last().trim(' ')
		mut parent_command := ''
		for i := parts.len - 1; i >= 0; i-- {
			if parts[i].starts_with('-') {
				continue
			}
			parent_command = parts[i]
			break
		}
		get_flags := fn (base []string, flag string) []string {
			if flag.len == 1 { return base
			 } else { return base.filter(it.starts_with(flag))
			 }
		}
		if part.starts_with('-') { // 'v -<tab>' -> flags.
			match parent_command {
				'bin2v' { // 'v bin2v -<tab>'
					list = get_flags(auto_complete_flags_bin2v, part)
				}
				'build' { // 'v build -<tab>' -> flags.
					list = get_flags(auto_complete_flags, part)
				}
				'doc' { // 'v doc -<tab>' -> flags.
					list = get_flags(auto_complete_flags_doc, part)
				}
				'fmt' { // 'v fmt -<tab>' -> flags.
					list = get_flags(auto_complete_flags_fmt, part)
				}
				'self' { // 'v self -<tab>' -> flags.
					list = get_flags(auto_complete_flags_self, part)
				}
				'shader' { // 'v shader -<tab>' -> flags.
					list = get_flags(auto_complete_flags_shader, part)
				}
				else {
					for flag in auto_complete_flags {
						if flag == part {
							if flag == '-cc' { // 'v -cc <tab>' -> list of available compilers.
								for compiler in auto_complete_compilers {
									path := os.find_abs_path_of_executable(compiler) or { '' }
									if path != '' {
										list << compiler
									}
								}
							}
						} else if flag.starts_with(part) { // 'v -<char(s)><tab>' -> flags matching "<char(s)>".
							list << flag
						}
					}
				}
			}
		} else {
			match part {
				'help' { // 'v help <tab>' -> top level commands except "help".
					list = auto_complete_commands.filter(it != part && it != 'complete')
				}
				else {
					// 'v <char(s)><tab>' -> commands matching "<char(s)>".
					// Don't include if part matches a full command - instead go to path completion below.
					for command in auto_complete_commands {
						if part != command && command.starts_with(part) {
							list << command
						}
					}
				}
			}
		}
		// Nothing of value was found.
		// Mimic shell dir and file completion
		if list.len == 0 {
			mut ls_path := '.'
			mut collect_all := part in auto_complete_commands
			mut path_complete := false
			do_home_expand = part.starts_with('~')
			if do_home_expand {
				add_sep := if part == '~' { os.path_separator } else { '' }
				part = part.replace_once('~', os.home_dir().trim_right(os.path_separator)) + add_sep
			}
			is_abs_path := part.starts_with(os.path_separator) // TODO Windows support for drive prefixes
			if part.ends_with(os.path_separator) || part == '.' || part == '..' {
				// 'v <command>(.*/$|.|..)<tab>' -> output full directory list
				ls_path = '.' + os.path_separator + part
				if is_abs_path {
					ls_path = nearest_path_or_root(part)
				}
				collect_all = true
			} else if !collect_all && part.contains(os.path_separator) && os.is_dir(os.dir(part)) {
				// 'v <command>(.*/.* && os.is_dir)<tab>'  -> output completion friendly directory list
				if is_abs_path {
					ls_path = nearest_path_or_root(part)
				} else {
					ls_path = os.dir(part)
				}
				path_complete = true
			}

			entries := os.ls(ls_path) or { return list }
			mut last := part.all_after_last(os.path_separator)
			if is_abs_path && os.is_dir(part) {
				last = ''
			}
			if path_complete {
				path := part.all_before_last(os.path_separator)
				for entry in entries {
					if entry.starts_with(last) {
						list << append_separator_if_dir(os.join_path(path, entry))
					}
				}
			} else {
				for entry in entries {
					if collect_all || entry.starts_with(last) {
						list << append_separator_if_dir(entry)
					}
				}
			}
		}
	}
	if do_home_expand {
		return list.map(it.replace_once(os.home_dir().trim_right(os.path_separator), '~'))
	}
	return list
}

fn setup_for_shell(shell string) string {
	mut setup := ''
	match shell {
		'bash' {
			setup = '
_v_completions() {
	local src
	local limit
	# Send all words up to the word the cursor is currently on
	let limit=1+\$COMP_CWORD
	src=\$($vexe complete bash \$(printf "%s\\n" \${COMP_WORDS[@]: 0:\$limit}))
	if [[ \$? == 0 ]]; then
		eval \${src}
		#echo \${src}
	fi
}

complete -o nospace -F _v_completions v
'
		}
		'fish' {
			setup = '
function __v_completions
	# Send all words up to the one before the cursor
	$vexe complete fish (commandline -cop)
end
complete -f -c v -a "(__v_completions)"
'
		}
		'zsh' {
			setup = '
#compdef v
_v() {
	local src
	# Send all words up to the word the cursor is currently on
	src=\$($vexe complete zsh \$(printf "%s\\n" \${(@)words[1,\$CURRENT]}))
	if [[ \$? == 0 ]]; then
		eval \${src}
		#echo \${src}
	fi
}
compdef _v v
'
		}
		'powershell' {
			setup = '
Register-ArgumentCompleter -Native -CommandName v -ScriptBlock {
	param(\$commandName, \$wordToComplete, \$cursorPosition)
		$vexe complete powershell "\$wordToComplete" | ForEach-Object {
			[System.Management.Automation.CompletionResult]::new(\$_, \$_, \'ParameterValue\', \$_)
		}
}
'
		}
		else {}
	}
	return setup
}

fn main() {
	args := os.args[1..]
	// println('"$args"')
	auto_complete(args)
}
