package one.frei.masterpass;

import java.util.HashMap;
import android.app.Activity;
import android.content.*;
import com.oltio.liblite.activity.LibLiteActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.*;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.*;

/**
 * MasterpassPlugin
 */
public class MasterpassPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
    public static final int REQUEST_CODE = 10;
    private final Activity activity;
    private Result result;

    /**
     * Constructor - received and assigns activity.
     */
    private MasterpassPlugin(Activity activity) {
        this.activity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "masterpass");
        final MasterpassPlugin plugin = new MasterpassPlugin(registrar.activity());

        channel.setMethodCallHandler(plugin);
        registrar.addActivityResultListener(plugin);
    }

    /**
     * Handle any method calls from flutter. Currently only necessary to handle the checkout method call,
     * which must pass string values for the "code", "system", and "key" keys in arguments. These values should
     * represent:
     * - "code": the transaction code
     * - "system": "Live" or "Test"
     * - "key": the masterpass api key
     */
    @Override
    public void onMethodCall(MethodCall call, Result result) {
        this.result = result;
        if (call.method.equals("checkout")) {
            doMasterpassCheckout(call.argument("code"), call.argument("system"), call.argument("key"));
        } else {
            result.notImplemented();
        }
    }

    /**
     * Perform the masterpass checkout with the given transaction code, system ("Test" or "Live"), and api key.
     */
    private void doMasterpassCheckout(String code, String system, String key) {
        Intent intent = new Intent(activity, LibLiteActivity.class);
        intent.putExtra(LibLiteActivity.IN_CODE, code);
        intent.putExtra(LibLiteActivity.IN_API_KEY, key);
        intent.putExtra(LibLiteActivity.IN_SYSTEM, system);
        activity.startActivityForResult(intent, REQUEST_CODE);
    }

    /**
     * Handle the result when the masterpass checkout is complete. In our case we are returning a
     * string to the flutter plugin representative of the result, ie:
     * - "OUT_ERROR_CODE": error has occurred before the payment.
     * - "PAYMENT_SUCCEEDED": the payment was successful.
     * - "PAYMENT_FAILED": the payment was unsuccessful.
     * - "USER_CANCELLED": the user cancelled the payment.
     * - "INVALID_CODE": the transaction code was invalid.
     */
    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE) {
            if (resultCode == LibLiteActivity.LIBLITE_ERROR) {
                CheckoutResult checkoutResult = new CheckoutResult("OUT_ERROR_CODE", "no ref. for this result");
                this.result.success(checkoutResult.toHashMap());
            } else if (resultCode == LibLiteActivity.LIBLITE_PAYMENT_SUCCESS) {
                CheckoutResult checkoutResult = new CheckoutResult("PAYMENT_SUCCEEDED", data.getStringExtra(LibLiteActivity.OUT_TX_REFERENCE));
                this.result.success(checkoutResult.toHashMap());
            } else if (resultCode == LibLiteActivity.LIBLITE_PAYMENT_FAILED) {
                CheckoutResult checkoutResult = new CheckoutResult("PAYMENT_FAILED", data.getStringExtra(LibLiteActivity.OUT_TX_REFERENCE));
                this.result.success(checkoutResult.toHashMap());
            } else if (resultCode == LibLiteActivity.LIBLITE_USER_CANCELLED) {
                CheckoutResult checkoutResult = new CheckoutResult("USER_CANCELLED", "no ref. for this result");
                this.result.success(checkoutResult.toHashMap());
            } else if (resultCode == LibLiteActivity.LIBLITE_INVALID_CODE) {
                CheckoutResult checkoutResult = new CheckoutResult("INVALID_CODE", "no ref. for this result");
                this.result.success(checkoutResult.toHashMap());
            }
        }
        return true;
    }
}

/**
 * Models a masterpass checkout result. An instance of this class is returned to the flutter plugin
 * as a HashMap.
 */
class CheckoutResult {
    /**
     * The result code
     */
    private String code;

    /**
     * The payment reference, only applicable to successful/unsuccessful payments
     */
    private String reference;

    /**
     * Constructor
     */
    public CheckoutResult(String code, String reference) {
        this.code = code;
        this.reference = reference;
    }

    /**
     * Returns a HashMap representative of this class
     */
    public HashMap<String, String> toHashMap() {
        HashMap<String, String> map = new HashMap<>();
        map.put("code", this.code);
        map.put("reference", this.reference);

        return map;
    }
}