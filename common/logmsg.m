function logmsg (logfile, msg)
    %logfile = [mfilename('fullpath'), '.log'];
    fh = fopen(logfile, 'a+');
    fprintf(fh, ['[', datestr(now, 'yyyy/mm/dd HH:MM:SS'), '] ', msg, '\n']);
    fclose(fh);
end

function log_ (msg)
	logfile = [mfilename('fullpath'), '.log'];
    fh = fopen(logfile, 'a+');
    fprintf(fh, ['[', datestr(now, 'yyyy/mm/dd HH:MM:SS'), '] ', msg, '\n']);
	fclose(fh);
end
