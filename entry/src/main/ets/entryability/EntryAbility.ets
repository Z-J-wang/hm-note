import { AbilityConstant, common, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import KvmUtil from '../utils/KvmUtil';

/**
 * 创建KVManager实例并创建获取数据库
 * @param context
 */
const createKvm = (context: common.UIAbilityContext) => {
  let kvManager: distributedKVStore.KVManager | undefined = undefined;
  const kvManagerConfig: distributedKVStore.KVManagerConfig = {
    context: context,
    bundleName: 'com.example.datamanagertest'
  };
  try {
    // 创建KVManager实例
    kvManager = distributedKVStore.createKVManager(kvManagerConfig);
    console.info('Succeeded in creating KVManager.');
    // 继续创建获取数据库
    const options: distributedKVStore.Options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: false,
      // kvStoreType不填时，默认创建多设备协同数据库
      kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
      // 多设备协同数据库：kvStoreType: distributedKVStore.KVStoreType.DEVICE_COLLABORATION,
      securityLevel: distributedKVStore.SecurityLevel.S1
    };
    kvManager.getKVStore<distributedKVStore.SingleKVStore>('storeId', options,
      (err, store: distributedKVStore.SingleKVStore) => {
        if (err) {
          console.error(`Failed to get KVStore: Code:${err.code},message:${err.message}`);
          return;
        }
        console.info('Succeeded in getting KVStore.');
        KvmUtil.setStore(store)
      });
  } catch (e) {
    let error = e as BusinessError;
    console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
  }
}

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    let context = this.context;
    createKvm(context)
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
