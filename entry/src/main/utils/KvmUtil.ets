import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

// kv实例类型
export interface KVEntry {
  key: string,
  value: Uint8Array | string | number | boolean
}

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
   * @returns {Promise<void | BusinessError>}
   */
  static put(key: string, value: Uint8Array | string | number | boolean): Promise<void | BusinessError> {
    return KvmUtil.kvStore.put(KvmUtil.prefix + key, value).then(() => {
      console.info('Succeeded in putting data.');
    }).catch((err: BusinessError) => {
      console.error(`An unexpected error occurred. Code:${err.code},message:${err.message}`);
      return err
    });
  }

  /**
   * 获取数据库的键值对
   * @returns { Promise<Uint8Array | string | number | boolean | BusinessError>}
   */
  static getAll(): Promise<KVEntry[] | BusinessError> {
    return KvmUtil.kvStore.getEntries(KvmUtil.prefix).then((entries: distributedKVStore.Entry[]) => {
      return entries.map(entry => {
        return {
          key: entry.key, value: entry.value.value
        } as KVEntry
      })
    }).catch((err: BusinessError) => {
      console.error(`Failed to get Entries.code is ${err.code},message is ${err.message}`);
      return err
    });
  }

  /**
   * 获取指定key对应的值
   * @param key
   * @returns { Promise<Uint8Array | string | number | boolean | BusinessError>}
   */
  static getKey(key: string): Promise<Uint8Array | string | number | boolean | BusinessError> {
    return KvmUtil.kvStore.get(KvmUtil.prefix + key).then((data: Uint8Array | string | number | boolean) => {
      return data
    }).catch((err: BusinessError) => {
      console.error(`Failed to get.code is ${err.code},message is ${err.message}`);
      return err
    });
  }

  /**
   * 删除指定key
   * @param key
   * @returns {Promise<void | BusinessError>}
   */
  static delete(key: string): Promise<void | BusinessError> {
    return KvmUtil.kvStore.delete(KvmUtil.prefix + key).then(() => {
      console.info('Succeeded in deleting');
    }).catch((err: BusinessError) => {
      console.error(`Failed to delete.code is ${err.code},message is ${err.message}`);
      return err
    });
  }
}