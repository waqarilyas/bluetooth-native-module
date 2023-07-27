/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React from 'react';
import {View, Text, Button, NativeModules, SafeAreaView} from 'react-native';

const {BluetoothDevices} = NativeModules;

function App(): JSX.Element {
  const [devices, setDevices] = React.useState([]);

  const getAvailableBluetoothDevices = async () => {
    try {
      BluetoothDevices.fetchBluetoothDevices((response: string[]) => {
        console.log('Discovered Bluetooth devices:', response);
      });

      setDevices(devices);
    } catch (error) {
      console.log(
        '🚀 ~ file: App.tsx:25 ~ getAvailableBluetoothDevices ~ error:',
        error,
      );
      console.error(error);
    }
  };
  return (
    <SafeAreaView>
      <View>
        <Button
          title="Scan for Devices"
          onPress={getAvailableBluetoothDevices}
        />
        <Text>Available Devices:</Text>
        {devices.map((device, index) => (
          <Text key={index}>{device}</Text>
        ))}
      </View>
    </SafeAreaView>
  );
}

export default App;
