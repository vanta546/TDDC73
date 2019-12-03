import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, Image, Button } from 'react-native';

export default class HomeScreen extends Component {
    render(){
        return <View>HEj</View>;
    }
}

export default class HomeScreen extends Component {
    static navigationOptions = {
        title: 'Piff och Puff',
        headerStyle: {
            backgroundColor: '#Ca3433',
        },
    };
    render() {
        return (
            <View style={styles.container}>



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

            </View>
        );
    }
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 20,
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
  }
});

