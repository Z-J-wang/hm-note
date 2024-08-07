import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

interface kv {
  key: string,
  value: Uint8Array | string | number | boolean
}

// TODO 完善KVM数据接口，增删改查
export default class KvmUtil {
  private static kvStore: distributedKVStore.SingleKVStore
  private static prefix: string = 'NODE_'

  static setStore(store: distributedKVStore.SingleKVStore) {
    KvmUtil.kvStore = store;
  }

  static getStore(): distributedKVStore.SingleKVStore {
    return KvmUtil.kvStore;
  }

  /**
   * 添加指定类型键值对到数据库
   * @param key
   * @param value
   */
  static put(key: string, value: Uint8Array | string | number | boolean) {
    try {
      KvmUtil.kvStore.put(KvmUtil.prefix + key, value, (err) => {
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

  static getAll() {
    try {
      KvmUtil.kvStore.getEntries(KvmUtil.prefix, (err: BusinessError, entries: distributedKVStore.Entry[]) => {
        if (err != undefined) {
          console.error(`Failed to get Entries.code is ${err.code},message is ${err.message}`);
          return;
        }
        console.info('Succeeded in getting Entries');
        return entries.map(entry => {
          return {
            key: entry.key, value: entry.value.value
          } as kv
        })
      });
    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to get data. Code:${error.code},message:${error.message}`);
    }
  }

  static getKey(key: string): Promise<Uint8Array | string | number | boolean | void> {
    return KvmUtil.kvStore.get(KvmUtil.prefix + key).then((data: Uint8Array | string | number | boolean) => {
      console.info(`Succeeded in getting data.data=${data}`);
      return data
    }).catch((err: BusinessError) => {
      console.error(`Failed to get.code is ${err.code},message is ${err.message}`);
    });
  }

  /**
   * 删除指定key
   * @param key
   * @returns {Promise<void>}
   */
  static delete(key: string): Promise<void> {
    return KvmUtil.kvStore.delete(KvmUtil.prefix + key).then(() => {
      console.info('Succeeded in deleting');
    }).catch((err: BusinessError) => {
      console.error(`Failed to delete.code is ${err.code},message is ${err.message}`);
    });

  }
}