/*
 * HaxeCommit.hx
 * Retrieves the first seven characters of the commit hash for this repo and stores it as a variable.
 * @see https://code.haxe.org/category/macros/add-git-commit-hash-in-build.html
 */
package compiletime;

// this is from enigma engine btw, kudos to EliteMasterEric
// yes it's on the haxe cookbook, but I'm lazy :P
class HaxeCommit
{
	public static macro function getGitCommitHash():haxe.macro.Expr.ExprOf<String>
	{
		#if !commit return macro $v{null}; #end 
		#if !display
		// Get the current line number.
		var pos = haxe.macro.Context.currentPos();

		var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
		if (process.exitCode() != 0)
		{
			var message = process.stderr.readAll().toString();
			haxe.macro.Context.info('[WARN] Could not determine current git commit; is this a proper Git repository?', pos);
		}

		// read the output of the process
		var commitHash = process.stdout.readLine();
		var commitHashSplice:String = commitHash.substr(0, 7);

		// haxe.macro.Context.info('[INFO] We are building in git commit ${commitHashSplice}', pos);

		// Generates a string expression
		return macro $v{commitHashSplice};
		#else
		// `#if display` is used for code completion. In this case returning an
		// empty string is good enough; We don't want to call git on every hint.
		var commitHash:String = "";
		return macro $v{commitHashSplice};
		#end
	}
}
