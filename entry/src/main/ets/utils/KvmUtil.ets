import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

// TODO 完善KVM数据接口，增删改查
export default class KvmUtil {
  private static kvStore: distributedKVStore.SingleKVStore

  static setStore(store: distributedKVStore.SingleKVStore) {
    KvmUtil.kvStore = store;
  }

  static getStore(): distributedKVStore.SingleKVStore {
    return KvmUtil.kvStore;
  }

  static put() {
    const KEY_TEST_STRING_ELEMENT = 'key_test_string';
    const VALUE_TEST_STRING_ELEMENT = 'value_test_string';
    try {
      KvmUtil.kvStore.put(KEY_TEST_STRING_ELEMENT, VALUE_TEST_STRING_ELEMENT, (err) => {
        if (err !== undefined) {
          console.error(`Failed to put data. Code:${err.code},message:${err.message}`);
          return;
        }
        console.info('Succeeded in putting data.');
      });
    } catch (e) {
      let error = e as BusinessError;
      console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
    }
  }

  static getKey() {
    const KEY_TEST_STRING_ELEMENT = 'key_test_string';
    try {
      KvmUtil.kvStore.get(KEY_TEST_STRING_ELEMENT, (err, data) => {
        if (err != undefined) {
          console.error(`Failed to get data. Code:${err.code},message:${err.message}`);
          return;
        }
        console.info(`Succeeded in getting data. Data:${data}`);
      });
    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to get data. Code:${error.code},message:${error.message}`);
    }
  }
}