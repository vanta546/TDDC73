import React from 'react';
import {
  StyleSheet,
  View,
  Text,
  StatusBar,
  Image,
  Button,
} from 'react-native';

import {
  Header,
  Input,
} from 'react-native-elements';

const App = () => {
  return (
    <View style={styles.container}>
        <StatusBar barStyle="dark-content" />
        <Header centerComponent={{text: 'Piff och Puff', style: {color: 'white', fontSize: 25}}}/>

        <Image source={require('./piffopuff.png')} />

        <View style={styles.row}>
        
            <View style={styles.col}>
                <View style={styles.ButtonStyle}>
                    <Button title="BUTTON" color="grey"/>
                </View>
                <View style={styles.ButtonStyle}>
                    <Button title="BUTTON" color="grey"/>
                </View>
            </View>

            <View style={styles.col}>
                <View style={styles.ButtonStyle}>
                    <Button title="BUTTON" color="grey"/>
                </View>
                <View style={styles.ButtonStyle}>
                    <Button title="BUTTON" color="grey"/>
                </View> 
            </View>
            
        </View>
           <Input placeholder='Email'/> 

    </View>
  );
};


const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  col: {
    margin: 20,
    flexDirection: 'column',
  },
  row: {
      flexDirection: 'row',
      padding: 10,
  },
  ButtonStyle: {
    margin: 10,
  },
  Headerstyle: {
      height: 10,
  }
});

export default App;
