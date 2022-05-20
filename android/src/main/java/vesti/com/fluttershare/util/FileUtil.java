package vesti.com.fluttershare.util;

import android.content.Context;
import android.net.Uri;
import androidx.core.content.FileProvider;
import java.io.File;

public class FileUtil {

    private final String authorities;
    private final Context context;
    private String url;
    private Uri uri;

    public FileUtil(Context applicationContext, String url) {
        this.url = url;
        this.uri = Uri.parse(this.url);
        this.context = applicationContext;
        authorities = applicationContext.getPackageName() + ".provider";
    }

    public Uri getPath() {
        Uri uri = Uri.parse(this.url);
        return FileProvider.getUriForFile(context, authorities, new File(uri.getPath()));
    }
}