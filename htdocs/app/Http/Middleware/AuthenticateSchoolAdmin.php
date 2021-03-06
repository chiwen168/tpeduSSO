<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class AuthenticateSchoolAdmin
{
    public function handle($request, Closure $next, $guard = null)
    {
        $user = $request->user();
        $dc = $request->route('dc');
        if (Auth::guard($guard)->guest() || !is_array($user->ldap['adminSchools']) || !in_array($dc, $user->ldap['adminSchools'])) {
            if ($request->ajax() || $request->wantsJson()) {
                return response('Unauthorized.', 401);
            } else {
                return redirect('/');
            }
        }
        return $next($request);
    }
}
